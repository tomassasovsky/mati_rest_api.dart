import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart' as http_interceptor;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mati_rest_api/mati_rest_api.dart';
import 'package:mati_rest_api/src/interceptors/token_interceptor.dart';
import 'package:mati_rest_api/src/mati_rest_api_base.dart';
import 'package:meta/meta.dart';

/// {@template mati_rest_api}
/// A library for interacting with the Mati REST API.
/// {@endtemplate}
class MatiRestApi implements MatiRestApiBase {
  /// {@macro mati_rest_api}
  MatiRestApi({
    required this.clientId,
    required this.clientSecret,
    http.Client? httpClient,
  }) {
    _httpClient = http_interceptor.InterceptedClient.build(
      interceptors: [
        TokenInterceptor(
          clientId: clientId,
          clientSecret: clientSecret,
          shouldUpdateToken: () => !validToken,
          onTokenUpdated: (newToken) => token = newToken,
        ),
      ],
      client: httpClient,
    );
  }

  /// The authority used for all API requests.
  ///
  /// Only exposed for testing purposes. Do not use directly.
  @visibleForTesting
  String get authority => 'api.getmati.com';

  /// Your client_id. You can find it in your Mati Dashboard.
  /// https://dashboard.getmati.com/dev
  ///
  /// Only exposed for testing purposes. Do not use directly.
  @visibleForTesting
  final String clientId;

  /// Your client_secret. You can find it in your Mati Dashboard.
  /// https://dashboard.getmati.com/dev
  ///
  /// Only exposed for testing purposes. Do not use directly.
  @visibleForTesting
  final String clientSecret;

  late final http.Client _httpClient;

  late final Finalizer<void> _finalizer = Finalizer(
    (connection) => _httpClient.close(),
  );

  /// The access token used for all API requests.
  @visibleForTesting
  String? token;

  /// Closes the underlying HTTP client.
  /// This should be called when the client is no longer needed.
  Future<void> close() async {
    _httpClient.close();
    _finalizer.detach(this);
  }

  @override
  Future<MatiResponse> getWebhookResourceData(String verificationId) async {
    final uri = Uri.https(
      authority,
      '/v2/verifications/$verificationId',
    );

    final response = await _httpClient.get(
      uri,
      headers: headers,
    );

    final body = jsonDecode(response.body) as Map?;

    switch (response.statusCode) {
      case 200:
        return MatiWebhookResourceData.fromMap(body!);
      default:
        try {
          return MatiErrorResponse.fromMap(body!);
        } on Exception {
          throw const MatiUnknownError();
        }
    }
  }

  /// The default headers.
  ///
  /// Only exposed for testing purposes. Do not use directly.
  @visibleForTesting
  Map<String, String> get headers => {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      };

  /// Whether the token is valid or not.
  @visibleForTesting
  bool get validToken => token != null && !JwtDecoder.isExpired(token!);
}
