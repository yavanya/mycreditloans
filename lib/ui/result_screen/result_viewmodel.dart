import 'package:stacked/stacked.dart';

import 'package:mycreditloans/main.dart';
import 'package:mycreditloans/api/random_api.dart';

class ResultViewModel extends FutureViewModel {
  final _api = getIt<RandomApi>();
  String? score;

  Future<String> getScore() async {
    final res = await _api.getRandomInt(
      min: 1,
      max: 10,
      count: 1,
    );
    //server delay imitation
    await Future.delayed(
      const Duration(seconds: 1),
    );
    return res.toString();
  }

  @override
  Future futureToRun() async {
    score = await getScore();
  }
}
