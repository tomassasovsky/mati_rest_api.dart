import 'package:mati_rest_api/mati_rest_api.dart';

/// {template mati_rest_api_base}
/// MatiRestApiBase is the base class for all API Requests available.
/// {endtemplate}
abstract class MatiRestApiBase {
  /// {@macro sportsvisio_api}
  const MatiRestApiBase();

  //* Verification
  /// Use this API to retrieve Webhook Resource Data.
  Future<MatiResponse> getWebhookResourceData(String verificationId);
}
