import 'package:mati_rest_api/mati_rest_api.dart';
import 'package:test/test.dart';

void main() {
  group('MatiRestApi', () {
    test('can be instantiated', () {
      expect(
        MatiRestApi(
          clientId: '',
          clientSecret: '',
        ),
        isNotNull,
      );
    });
  });
}
