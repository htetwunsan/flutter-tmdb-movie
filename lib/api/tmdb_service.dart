import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tmdb_movie/constants.dart';

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
    return Future<void>.value();
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
    return Future<void>.value();
  }
}

class TmdbService {
  Dio _dio = Dio(BaseOptions(
      baseUrl: Constants.BASE_URL + "${Constants.API_VERSION}/",
      queryParameters: {"api_key": Constants.API_KEY},
      connectTimeout: 10 * 1000,
      receiveTimeout: 10 * 1000));

  Future<Response> requestUpcomingMovies(int page) =>
      _dio.get("movie/upcoming?page=$page");

  Future<Response> requestDetailMovie(int movieId) =>
      _dio.get("movie/$movieId");
}
