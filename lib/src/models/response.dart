import 'package:equatable/equatable.dart';

/// {template mati_response}
/// MatiResponse is the response from the API.
/// {endtemplate}
abstract class MatiResponse extends Equatable {
  /// {@macro mati_response}
  const MatiResponse();

  @override
  List<Object?> get props => [];
}
