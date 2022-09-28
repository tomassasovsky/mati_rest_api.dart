import 'package:equatable/equatable.dart';

import 'package:mati_rest_api/mati_rest_api.dart';

/// {template authentication_response}
/// AuthenticationResponse is the successful
/// response from the authentication request.
/// {endtemplate}
class MatiAuthenticationResponse extends MatiResponse {
  /// {@macro authentication_response}
  const MatiAuthenticationResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.payload,
  });

  /// Creates a [MatiAuthenticationResponse] from a [Map].
  factory MatiAuthenticationResponse.fromMap(Map<dynamic, dynamic> map) {
    map = map.cast<String, dynamic>();

    final accessToken = map['access_token'] as String;
    final expiresIn = map['expiresIn'] as int;
    final payload = map['payload'] as Map;

    return MatiAuthenticationResponse(
      accessToken: accessToken,
      expiresIn: expiresIn,
      payload: MatiAuthenticationResponsePayload.fromMap(payload),
    );
  }

  /// The access token used to authenticate your requests.
  final String accessToken;

  /// Contains the user id.
  final MatiAuthenticationResponsePayload payload;

  /// The number of seconds until the access token expires.
  final int expiresIn;

  @override
  List<Object?> get props => [accessToken, payload, expiresIn];
}

/// {template authentication_response}
/// The payload included in the successful [MatiAuthenticationResponse].
/// {endtemplate}
class MatiAuthenticationResponsePayload extends Equatable {
  /// {@macro authentication_response}
  const MatiAuthenticationResponsePayload({
    required this.userId,
  });

  /// Creates a [MatiAuthenticationResponsePayload] from a [Map].
  factory MatiAuthenticationResponsePayload.fromMap(Map<dynamic, dynamic> map) {
    map = map.cast<String, dynamic>();

    final user = map['user'] as Map<dynamic, dynamic>?;
    final userId = user?['_id'] as String?;

    return MatiAuthenticationResponsePayload(
      userId: userId,
    );
  }

  /// The user id.
  final String? userId;

  @override
  List<Object?> get props => [userId];
}
