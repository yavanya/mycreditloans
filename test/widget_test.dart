import 'package:flutter_test/flutter_test.dart';

import 'package:mycreditloans/api/random_api.dart';
import 'package:mycreditloans/main.dart';

void main() {
  test('RandomApi test', () async {
    const min = 1;
    const max = 5;
    const count = 1;
    getIt.registerSingleton<RandomApi>(RandomApi());
    final _randApi = getIt<RandomApi>();
    expect(
        await _randApi.getRandomInt(
          min: min,
          max: max,
          count: count,
        ),
        (String r) => int.parse(r) <= max && int.parse(r) >= min);
  });
}
