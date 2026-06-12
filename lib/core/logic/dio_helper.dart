import 'dart:io';

import 'package:dio/dio.dart';
import 'package:glovana_provider/views/auth/login/view.dart';

import 'app_logger.dart';
import 'cache_helper.dart';
import 'helper_methods.dart';

enum APIMethods { post, put, delete }

class DioHelper {
  final _dio = Dio(
    BaseOptions(
      receiveDataWhenStatusError: true,
      baseUrl: 'https://glovana.net/api/v1/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        if (CacheHelper.token.isNotEmpty)
          'Authorization': 'Bearer ${CacheHelper.token}',
      },
    ),
  );

  DioHelper() {
    _dio.interceptors.add(CustomApiInterceptor());
  }

  Future<CustomResponse> fakeCase() async {
    await Future.delayed(const Duration(seconds: 1));
    return CustomResponse(isSuccess: true, msg: 'status');
  }

  Future<Response> getResponse(
    String path,
    dynamic data,
    Map<String, dynamic>? headers,
    APIMethods method,
    Map<String, dynamic>? params,
  ) async {
    switch (method) {
      case APIMethods.post:
        return _dio.post(
          path,
          options: Options(headers: headers),
          data: data,
          queryParameters: params,
        );
      case APIMethods.put:
        return _dio.put(
          path,
          options: Options(headers: headers),
          data: data,
          queryParameters: params,
        );
      case APIMethods.delete:
        return _dio.delete(
          path,
          options: Options(headers: headers),
          data: data,
          queryParameters: params,
        );
    }
  }

  Future<CustomResponse> send(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? rawData,
    Map<String, dynamic>? headers,
    APIMethods method = APIMethods.post,
  }) async {
    if (path.isEmpty) {
      return fakeCase();
    }

    try {
      final body = method == APIMethods.delete && rawData != null
          ? rawData
          : data;
      final response = await getResponse(path, body, headers, method, params);
      return _buildCustomResponse(response);
    } on DioException catch (error) {
      return handleServerError(error);
    }
  }

  Future<CustomResponse> deleteData({
    required String url,
    Map<String, dynamic>? query,
    Object? data,
    String? lang,
    String? token,
  }) async {
    try {
      _dio.options.headers = _headers(
        lang: lang,
        token: token,
        contentType: 'application/json',
      );

      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: query,
      );

      return _buildCustomResponse(
        response,
        fallbackSuccess: 'Success',
        fallbackError: 'Failed',
      );
    } on DioException catch (error) {
      return handleServerError(error);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unexpected delete request failure',
        tag: 'HTTP',
        error: error,
        stackTrace: stackTrace,
      );

      return CustomResponse(
        data: null,
        msg: 'Unexpected error occurred. Please try again later.',
      );
    }
  }

  Future<Response> postData({
    required String url,
    dynamic data,
    String? lang,
    String? token,
    Map<String, dynamic>? query,
    bool withFiles = false,
  }) async {
    _dio.options.headers = _headers(
      lang: lang,
      token: token,
      contentType: withFiles ? 'multipart/form-data' : 'application/json',
    );

    return _dio.post(url, data: data, queryParameters: query);
  }

  Future<Response> putData({
    required String url,
    dynamic data,
    String? lang,
    String? token,
    Map<String, dynamic>? query,
  }) async {
    _dio.options.headers = _headers(
      lang: lang,
      token: token,
      contentType: 'multipart/form-data',
    );

    return _dio.put(url, data: data, queryParameters: query);
  }

  Future<CustomResponse> get(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    if (path.isEmpty) {
      return fakeCase();
    }

    try {
      params?.removeWhere(
        (key, value) => value == null || value.toString().isEmpty,
      );
      final response = await _dio.get(path, queryParameters: params);
      return _buildCustomResponse(response);
    } on DioException catch (error) {
      return handleServerError(error);
    }
  }

  CustomResponse handleServerError(DioException error) {
    final message =
        _extractMessage(error.response?.data) ??
        NetworkExceptions.getDioException(error);

    return CustomResponse(
      statusCode: error.response?.statusCode ?? 500,
      msg: message,
      data: error.response?.data,
    );
  }

  CustomResponse _buildCustomResponse(
    Response response, {
    String fallbackSuccess = 'status',
    String fallbackError = 'Request failed.',
  }) {
    final responseMessage = NetworkExceptions.handleResponse(response);
    final payloadFailed = _isFailurePayload(response.data);
    final extractedMessage = _extractMessage(response.data);

    return CustomResponse(
      data: response.data,
      statusCode: response.statusCode,
      isSuccess: responseMessage == null && !payloadFailed,
      msg:
          extractedMessage ??
          responseMessage ??
          (payloadFailed ? fallbackError : fallbackSuccess),
    );
  }

  Map<String, String> _headers({
    String? lang,
    String? token,
    required String contentType,
  }) {
    return {
      'Accept-Language': lang ?? CacheHelper.lang,
      'Accept': 'application/json',
      'Content-Type': contentType,
      'Authorization': 'Bearer ${token ?? CacheHelper.token}',
    };
  }

  static bool _isFailurePayload(dynamic data) {
    if (data is String || data is List) {
      return true;
    }

    if (data is Map) {
      return data['status'] == false ||
          data['success'] == false ||
          data['code'] == 500;
    }

    return false;
  }

  static String? _extractMessage(dynamic data) {
    if (data is! Map) {
      return null;
    }

    final rawMessage = data['message'] ?? data['msg'] ?? data['error'];
    if (rawMessage == null) {
      return null;
    }

    final message = rawMessage.toString().trim();
    return message.isEmpty ? null : message;
  }
}

class CustomResponse {
  final String msg;
  final int? statusCode;
  final bool isSuccess;
  final dynamic data;

  CustomResponse({
    required this.msg,
    this.statusCode,
    this.isSuccess = false,
    this.data,
  });
}

class CustomApiInterceptor extends Interceptor {
  static const _requestStartKey = 'request_started_at';
  static bool _isHandlingUnauthorized = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_requestStartKey] = DateTime.now().millisecondsSinceEpoch;
    options.headers.addAll({'lang': CacheHelper.lang});

    if (CacheHelper.token.isNotEmpty && options.path != 'user/login') {
      options.headers['Authorization'] = 'Bearer ${CacheHelper.token}';
    }

    AppLogger.info(
      '--> ${options.method.toUpperCase()} ${options.uri}',
      tag: 'HTTP',
    );

    if (options.queryParameters.isNotEmpty) {
      AppLogger.debug(
        'Query parameters',
        tag: 'HTTP',
        data: options.queryParameters,
      );
    }

    final bodyPreview = _requestBodyPreview(options.data);
    if (bodyPreview != null) {
      AppLogger.debug('Request body', tag: 'HTTP', data: bodyPreview);
    }

    AppLogger.debug('Request headers', tag: 'HTTP', data: options.headers);
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    AppLogger.info(
      '<-- ${response.statusCode} ${response.requestOptions.method.toUpperCase()} '
      '${response.requestOptions.uri} (${_durationLabel(response.requestOptions)})',
      tag: 'HTTP',
    );
    AppLogger.debug('Response body', tag: 'HTTP', data: response.data);
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    AppLogger.error(
      'xx ${err.response?.statusCode ?? '-'} '
      '${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri} '
      '(${_durationLabel(err.requestOptions)})',
      tag: 'HTTP',
      error: err,
      data: {
        'message':
            DioHelper._extractMessage(err.response?.data) ??
            NetworkExceptions.getDioException(err),
        'response': err.response?.data,
      },
    );

    if (_shouldHandleUnauthorized(err)) {
      await _handleUnauthorized();
    }

    handler.next(err);
  }

  dynamic _requestBodyPreview(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is FormData) {
      return {
        'fields': {for (final field in data.fields) field.key: field.value},
        'files': [
          for (final file in data.files)
            {'key': file.key, 'filename': file.value.filename},
        ],
      };
    }

    return data;
  }

  String _durationLabel(RequestOptions options) {
    final startedAt = options.extra[_requestStartKey];
    if (startedAt is! int) {
      return 'n/a';
    }

    final duration = DateTime.now().millisecondsSinceEpoch - startedAt;
    return '$duration ms';
  }

  bool _shouldHandleUnauthorized(DioException error) {
    return error.response?.statusCode == 401 &&
        CacheHelper.isAuthed &&
        error.requestOptions.path != 'user/login';
  }

  Future<void> _handleUnauthorized() async {
    if (_isHandlingUnauthorized) {
      return;
    }

    _isHandlingUnauthorized = true;
    try {
      await CacheHelper.logOut();
      showMessage(
        'Your session expired. Please log in again.',
        type: MessageType.warning,
      );

      if (navigatorKey.currentState != null) {
        await navigateTo(const LoginView(), keepHistory: false);
      }
    } finally {
      _isHandlingUnauthorized = false;
    }
  }
}

abstract class NetworkExceptions {
  static String? handleResponse(Response response) {
    switch (response.statusCode ?? 0) {
      case 400:
        return 'Bad request. Please check your input and try again.';
      case 401:
        return 'Unauthorized request. Please log in again.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'Requested resource not found.';
      case 204:
        return DioHelper._extractMessage(response.data) ?? 'No data found.';
      case 408:
        return 'Connection request timeout. Please try again later.';
      case 409:
        return 'Error due to a conflict. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return null;
    }
  }

  static String getDioException(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          return 'Request cancelled.';
        case DioExceptionType.badCertificate:
          return 'Bad certificate.';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        case DioExceptionType.sendTimeout:
          return 'Send timeout in connection with API server. Please try again later.';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout in connection with API server. Please try again later.';
        case DioExceptionType.connectionTimeout:
          return 'Connection request timeout. Please try again later.';
        case DioExceptionType.badResponse:
          if (error.response != null) {
            return DioHelper._extractMessage(error.response?.data) ??
                handleResponse(error.response!) ??
                'Bad response from server.';
          }
          return 'Bad response from server.';
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return 'No internet connection.';
          }
          return 'Unexpected error occurred. Please try again later.';
      }
    }

    if (error is SocketException) {
      return 'No internet connection.';
    }

    if (error.toString().contains('is not a subtype of')) {
      return 'Unable to process the data. Please try again later.';
    }

    return 'Unexpected error occurred. Please try again later.';
  }
}
