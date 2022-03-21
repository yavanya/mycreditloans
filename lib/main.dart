import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mycreditloans/api/json_api.dart';
import 'package:mycreditloans/api/random_api.dart';
import 'package:mycreditloans/services/data_service.dart';
import 'package:mycreditloans/ui/preliminary_screen/preliminary_view.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<JsonApi>(JsonApi());
  getIt.registerSingleton<RandomApi>(RandomApi());
  getIt.registerSingleton<DataService>(DataService());
  await getIt<DataService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PreliminaryView(),
    );
  }
}
