import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:funngro_assessment/core/error/exceptions.dart';

Dio createDio({required String baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Accept': 'application/json'},
    ),
  );
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }
  return dio;
}

ApiException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return ApiException(
        'Please check your internet connection.',
        isNetwork: true,
      );
    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      return ApiException('Server error ($code).', statusCode: code);
    case DioExceptionType.cancel:
      return ApiException('Request cancelled.');
    default:
      return ApiException('Something went wrong.');
  }
}
