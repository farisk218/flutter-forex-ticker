import 'package:dio/dio.dart';
import 'package:flutter_trading_app/core/constants/app_urls.dart';
import 'package:flutter_trading_app/core/error/exceptions.dart';
import 'base_model.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;
  late Dio _dio;

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    );
    _dio = Dio(options);
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<List<T>> get<T extends BaseModel>({
    required String path,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      if (response.data is List) {
        return (response.data as List)
            .map((item) => fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.badResponse:
        return ServerException();
      case DioExceptionType.cancel:
        return RequestCancelledException();
      default:
        return NetworkException();
    }
  }
}
