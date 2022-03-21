import 'dart:convert';

import 'package:flutter/services.dart';

class JsonApi {
  Future<Map<String, dynamic>> getInitialData() async {
    final resJson = await rootBundle.loadString('assets/json/loans.json');

    final initialData = json.decode(resJson);

    return initialData;
  }
}
