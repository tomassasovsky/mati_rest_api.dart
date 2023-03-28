import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart' as http_interceptor;
import 'package:mati_rest_api/mati_rest_api.dart';
import 'package:meta/meta.dart';

/// {@template environment_checker}
/// Checks the environment for this version of the app,
/// and sets the authority accordingly.
/// {@endtemplate}
class TokenInterceptor implements http_interceptor.InterceptorContract {
  /// {@macro environment_checker}
  TokenInterceptor({
    required this.shouldUpdateToken,
    required this.clientId,
    required this.clientSecret,
    this.onTokenUpdated,
  });

  /// Whether to update the token.
  final bool Function() shouldUpdateToken;

  /// Called when the environment has been checked.
  final void Function(String token)? onTokenUpdated;

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

  @override
  Future<http_interceptor.RequestData> interceptRequest({
    required http_interceptor.RequestData data,
  }) async {
    final shouldUpdate = shouldUpdateToken();
    if (!shouldUpdate) {
      return data;
    }

    final token = await updateToken();
    if (token is MatiAuthenticationResponse) {
      data.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    return data;
  }

  @override
  Future<http_interceptor.ResponseData> interceptResponse({
    required http_interceptor.ResponseData data,
  }) async =>
      data;

  /// Use your client_id and client_secret as your username
  /// and password to get your access token.
  @visibleForTesting
  Future<MatiResponse> updateToken() async {
    const authority = 'api.getmati.com';
    final uri = Uri.https(authority, 'oauth');

    final clientCredentials = base64Encode(
      utf8.encode('$clientId:$clientSecret'),
    );

    final response = await http.post(
      uri,
      body: 'grant_type=client_credentials',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic $clientCredentials',
      },
    );

    final body = jsonDecode(response.body) as Map?;

    switch (response.statusCode) {
      case 200:
        final response = MatiAuthenticationResponse.fromMap(body!);
        onTokenUpdated?.call(response.accessToken);
        return response;
      case 400:
      case 401:
        return MatiErrorResponse.fromMap(body!);
      default:
        try {
          return MatiErrorResponse.fromMap(body!);
        } on Exception {
          throw const MatiUnknownError();
        }
    }
  }
}
