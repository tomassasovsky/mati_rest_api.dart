import 'package:mati_rest_api/mati_rest_api.dart';

/// {template error_response}
/// ErrorResponse is the error response from the API.
/// {endtemplate}
class MatiErrorResponse extends MatiResponse {
  /// {@macro error_response}
  const MatiErrorResponse({
    required this.code,
    required this.message,
    required this.name,
    required this.status,
    required this.statusCode,
  });

  /// Creates a [MatiErrorResponse] from a [Map].
  factory MatiErrorResponse.fromMap(Map<dynamic, dynamic> map) {
    map = map.cast<String, dynamic>();

    final code = map['code'] as int? ?? -1;
    final message = map['message'] as String? ?? 'MESSAGE NOT AVAILABLE';
    final name = map['name'] as String? ?? 'NAME NOT AVAILABLE';
    final status = map['status'] as int? ?? -1;
    final statusCode = map['statusCode'] as int? ?? -1;

    return MatiErrorResponse(
      code: code,
      message: message,
      name: name,
      status: status,
      statusCode: statusCode,
    );
  }

  /// The error code.
  final int code;

  /// The error message.
  final String message;

  /// The error name.
  final String name;

  /// The error status.
  final int status;

  /// The error status code.
  final int statusCode;

  @override
  List<Object?> get props {
    return [
      code,
      message,
      name,
      status,
      statusCode,
    ];
  }
}

/// {template mati_unknown_error}
/// MatiUnknownError is the error response from the API when
/// the error is unknown, so it was not possible to parse the error.
/// {endtemplate}
class MatiUnknownError implements Exception {
  /// {@macro mati_unknown_error}
  const MatiUnknownError();
}
