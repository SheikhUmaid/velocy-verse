import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:velocyverse/services/secure_storage_service.dart';
import 'package:velocyverse/utils/util.constants.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: Constants.baseURL,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          ) {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          request: true,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            // Try to refresh token
            final success = await _refreshAccessToken();
            if (success) {
              // Retry original request with new token
              final RequestOptions requestOptions = error.requestOptions;

              final newAccessToken = await SecureStorage.getAccessToken();
              requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';

              try {
                final cloneReq = await _dio.fetch(requestOptions);
                return handler.resolve(cloneReq);
              } catch (e) {
                return handler.reject(error);
              }
            }
          }
          return handler.next(error); // other errors
        },
      ),
    );
  }

  // 🔁 Refresh Token Method
  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth_api/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200 && response.data['access'] != null) {
        await SecureStorage.saveTokens(
          accessToken: response.data['access'],
          refreshToken: refreshToken, // Keep existing refresh
        );
        debugPrint("🔁 Access token refreshed");
        return true;
      }
    } catch (e) {
      debugPrint("❌ Failed to refresh token: $e");
    }
    return false;
  }

  Future<Response> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      // Set additional headers if provided.
      // if (headers != null) {
      //   _dio.options.headers.addAll(headers);
      // }
      final token = await SecureStorage.getAccessToken();
      final authHeader = {'Authorization': 'Bearer $token'};
      _dio.options.headers.addAll({...?headers, ...authHeader});

      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      // Handle errors appropriately (you might want to log or rethrow custom exceptions)
      throw Exception(_handleDioError(e));
    }
  }

  Future<Response> postRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final token = await SecureStorage.getAccessToken();
      final authHeader = {'Authorization': 'Bearer $token'};
      _dio.options.headers.addAll({...?headers, ...authHeader});

      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      // Handle structured error response from server
      if (e.response != null && e.response?.data != null) {
        // Forward a clean, readable error
        final message = e.response?.data['message'] ?? 'Unknown error';
        throw Exception(message); // This will be caught in the view
      } else {
        // If it's a network error or no response
        throw Exception(_handleDioError(e));
      }
    }
  }

  Future<Response> deleteRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final token = await SecureStorage.getAccessToken();
      final authHeader = {'Authorization': 'Bearer $token'};
      _dio.options.headers.addAll({...?headers, ...authHeader});

      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Response> putRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final token = await SecureStorage.getAccessToken();
      final authHeader = {'Authorization': 'Bearer $token'};
      _dio.options.headers.addAll({...?headers, ...authHeader});

      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final message = e.response?.data['message'] ?? 'Unknown error';
        throw Exception(message);
      } else {
        throw Exception(_handleDioError(e));
      }
    }
  }

  Future<Response> patchRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final token = await SecureStorage.getAccessToken();
      final authHeader = {'Authorization': 'Bearer $token'};
      _dio.options.headers.addAll({...?headers, ...authHeader});

      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final message = e.response?.data['message'] ?? 'Unknown error';
        throw Exception(message);
      } else {
        throw Exception(_handleDioError(e));
      }
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return "Request was cancelled";
      case DioExceptionType.connectionTimeout:
        return "Connection timeout with API server";
      case DioExceptionType.sendTimeout:
        return "Send timeout in connection with API server";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout in connection with API server";
      case DioExceptionType.badResponse:
        return "Received invalid status code: ${error.response?.statusCode}";
      case DioExceptionType.unknown:
      default:
        return "Connection to API server failed due to internet connection";
    }
  }
}
