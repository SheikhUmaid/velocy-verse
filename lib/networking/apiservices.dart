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
            final success = await _refreshAccessToken();
            if (success) {
              final RequestOptions requestOptions = error.requestOptions;
              final newAccessToken = await SecureStorage.getAccessToken();
              requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';

              try {
                final cloneReq = await _dio.fetch(requestOptions);
                return handler.resolve(cloneReq);
              } catch (_) {
                return handler.reject(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // 🔄 Refresh Token
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
          refreshToken: refreshToken,
        );
        debugPrint("🔁 Access token refreshed");
        return true;
      }
    } catch (e) {
      debugPrint("❌ Failed to refresh token: $e");
    }
    return false;
  }

  // 🔹 Centralized request handler
  Future<Response> _request(
    String method,
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool doesNotRequireAuthHeader = false,
  }) async {
    try {
      final requestHeaders = {...?headers};

      if (!doesNotRequireAuthHeader) {
        final token = await SecureStorage.getAccessToken();
        if (token != null) {
          requestHeaders['Authorization'] = 'Bearer $token';
        }
      }

      final options = Options(method: method, headers: requestHeaders);

      return await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final message = e.response?.data['message'] ?? 'Unknown error';
        throw Exception(message);
      }
      throw Exception(_handleDioError(e));
    }
  }

  // 🔹 Public methods
  Future<Response> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool doesNotRequireAuthHeader = false,
  }) => _request(
    'GET',
    path,
    queryParameters: queryParameters,
    headers: headers,
    doesNotRequireAuthHeader: doesNotRequireAuthHeader,
  );

  Future<Response> postRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool doesNotRequireAuthHeader = false,
  }) => _request(
    'POST',
    path,
    data: data,
    queryParameters: queryParameters,
    headers: headers,
    doesNotRequireAuthHeader: doesNotRequireAuthHeader,
  );

  Future<Response> putRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool doesNotRequireAuthHeader = false,
  }) => _request(
    'PUT',
    path,
    data: data,
    queryParameters: queryParameters,
    headers: headers,
    doesNotRequireAuthHeader: doesNotRequireAuthHeader,
  );

  Future<Response> patchRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool doesNotRequireAuthHeader = false,
  }) => _request(
    'PATCH',
    path,
    data: data,
    queryParameters: queryParameters,
    headers: headers,
    doesNotRequireAuthHeader: doesNotRequireAuthHeader,
  );

  Future<Response> deleteRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool doesNotRequireAuthHeader = false,
  }) => _request(
    'DELETE',
    path,
    queryParameters: queryParameters,
    headers: headers,
    doesNotRequireAuthHeader: doesNotRequireAuthHeader,
  );

  // 🔹 Error handler
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
