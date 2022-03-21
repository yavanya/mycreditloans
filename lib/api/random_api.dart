import 'package:dio/dio.dart';

class RandomApi {
  final _dio = Dio();
  final _endPoint = 'https://www.random.org/integers/';

  Future<String> getRandomInt({
    required int min,
    required int max,
    required int count,
  }) async {
    final params = {
      'num': count,
      'min': min,
      'max': max,
      'col': 1,
      'base': 10,
      'format': 'plain',
      'rnd': 'new'
    };

    final options = Options(
      method: 'GET',
    );

    Response? resDio;

    try {
      resDio = await _dio.request(
        _endPoint,
        queryParameters: params,
        options: options,
      );
    } catch (e) {
      if (e is DioError) {
        //TODO implement Dio error processing
      } else {
        //TODO implement other/unknown error processing
      }
    }

    if (resDio != null && resDio.data != null && resDio.data.isNotEmpty) {
      return resDio.data;
    }

    return '';
  }
}
