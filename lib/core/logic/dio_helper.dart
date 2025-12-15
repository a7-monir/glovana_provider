import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:glovana_provider/views/auth/login/view.dart';
import 'package:quick_log/quick_log.dart';

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
        "Accept": "application/json",
        if (CacheHelper.token.isNotEmpty)
          "Authorization": "Bearer ${CacheHelper.token}",
      },
    ),
  );

  DioHelper() {
    _dio.interceptors.add(CustomApiInterceptor());
  }

  Future<CustomResponse> fakeCase() async {
    await Future.delayed(const Duration(seconds: 1));
    return CustomResponse(isSuccess: true, msg: "status");
  }

  Future<Response> getResponse(
    String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    APIMethods method,
    Map<String, dynamic>? params,
  ) async {
    late Response resp;
    if (method == APIMethods.post) {
      resp = await _dio.post(
        path,
        options: Options(headers: headers),
        data: data,
        queryParameters: params,
      );
    } else if (method == APIMethods.put) {
      resp = await _dio.put(path, data: data, queryParameters: params);
    } else if (method == APIMethods.delete) {
      resp = await _dio.delete(path, data: data, queryParameters: params);
    }
    return resp;
  }

  // Future<CustomResponse> send(
  //     String path, {
  //       Map<String, dynamic>? data,
  //       Map<String, dynamic>? params,
  //       Map<String, dynamic>? rawData,
  //       Map<String, dynamic>? headers,
  //       APIMethods method = APIMethods.post,
  //     }) async {
  //   if (path.isEmpty) {
  //     return fakeCase();
  //   }
  //
  //   try {
  //     headers ??= {
  //       'Accept': 'application/json',
  //     };
  //
  //     // ✅ DELETE لازم JSON
  //     if (method == APIMethods.delete) {
  //       headers['Content-Type'] = 'application/json';
  //     }
  //
  //     /// ✅ body اللي هيتبعت فعليًا
  //     final Map<String, dynamic>? body =
  //     method == APIMethods.delete
  //         ? (rawData ?? {})
  //         : data;
  //
  //     final resp = await getResponse(
  //       path,
  //       body,
  //       headers,
  //       method,
  //       params,
  //     );
  //
  //     if (resp.data is Map &&
  //         (resp.data["status"] == false ||
  //             resp.data["code"] == 500)) {
  //       return CustomResponse(
  //         data: resp.data,
  //         msg: resp.data["message"],
  //         isSuccess: false,
  //       );
  //     }
  //
  //     return CustomResponse(
  //       data: resp.data,
  //       isSuccess: true,
  //       msg: resp.data["message"] ?? "status",
  //     );
  //   } on DioException catch (ex) {
  //     return handleServerError(ex);
  //   }
  // }

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
      final body =
      method == APIMethods.delete && rawData != null
          ? rawData
          : data;

      final resp = await getResponse(
        path,
        body,
        headers,
        method,
        params,
      );

      if ([500].contains(resp.data["code"]) ||
          resp.data["status"] == false) {
        return CustomResponse(
          data: resp.data,
          msg: resp.data["message"],
          isSuccess: false,
        );
      }

      return CustomResponse(
        data: resp.data,
        isSuccess: true,
        msg: resp.data["message"] ?? "status",
      );
    } on DioException catch (ex) {
      return handleServerError(ex);
    }
  }
  // deleteData({
  //   required String url,
  //   Map<String, dynamic>? query,
  //   data,
  //   String? lang,
  //   String? token,
  // }) async {
  //   try {
  //     ـdio.options.headers = {
  //       'Authorization':
  //            "Bearer  ${CacheHelper.token}"
  //           ,
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //       'Accept-Language': lang ?? CacheHelper.lang
  //     };
  //
  //     var res = await _dio.delete(url, queryParameters: query, data: data);
  //
  //     return res;
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  Future<CustomResponse> deleteData({
    required String url,
    Map<String, dynamic>? query,
    Object? data,
    String? lang,
    String? token,
  }) async {
    try {
      _dio.options.headers = {
        'Authorization': "Bearer ${token ?? CacheHelper.token}",
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': lang ?? CacheHelper.lang,
      };

      // ❌ تجنب dio.delete لأنه أحيانًا يتجاهل body
      final res = await _dio.delete(
        url,
        data: data,
        queryParameters: query,
      );

      // ✅ التحقق من response
      if ([500].contains(res.data["code"]) || res.data["status"] == false) {
        return CustomResponse(
          data: res.data,
          msg: res.data["message"] ?? "Failed",
          isSuccess: false,
        );
      }

      return CustomResponse(
        data: res.data,
        msg: res.data["message"] ?? "Success",
        isSuccess: true,
      );
    } on DioException catch (ex) {
      return handleServerError(ex);
    } catch (e) {
      // أي error غير dio
      return CustomResponse(
        data: null,
        msg: e.toString(),
        isSuccess: false,
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
    _dio.options.headers = {
      'Accept-Language': lang ?? CacheHelper.lang,
      'Accept': 'application/json',
      'Content-Type': withFiles ? "multipart/form-data" : "application/json",
      "Authorization": "Bearer ${CacheHelper.token}",
    };

    try {
      var res = await _dio.post(url, data: data, queryParameters: query);

      return res;
    } on DioException catch (e) {
      rethrow;
    }
  }
  Future<Response> putData({
    required String url,
    dynamic data,
    String? lang,
    String? token,
    Map<String, dynamic>? query,
  }) async {
    _dio.options.headers = {
      'Accept-Language': CacheHelper.lang,
      'Accept': 'application/json',
      'Content-Type': "multipart/form-data",
      "Authorization": "Bearer ${CacheHelper.token}",
    };
    var res = await _dio.put(
      url,
      data: data,
      queryParameters: query,
    );

    return res;
  }

  Future<CustomResponse> get(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    if (path.isEmpty) {
      return fakeCase();
    } else {
      try {
        params?.removeWhere(
          (key, value) => value == null || value.toString().isEmpty,
        );
        final resp = await _dio.get(path, queryParameters: params);

        print(resp.data.runtimeType);

        if (resp.data is String ||
            resp.data is List ||
            [500].contains(resp.data["code"]) ||
            resp.data["status"] == false) {
          return CustomResponse(
            data: resp.data,
            msg: resp.data?["message"],
            isSuccess: false,
          );
        }
        return CustomResponse(
          data: resp.data,
          isSuccess: NetworkExceptions.handleResponse(resp) == null,
          msg: NetworkExceptions.handleResponse(resp) ?? resp.data["message"],
        );
      } on DioException catch (ex) {
        return handleServerError(ex);
      }
    }
  }

  CustomResponse handleServerError(DioException err) {
    String msg;
    try {
      msg = err.response?.data?["message"];
    } catch (ex) {
      msg = NetworkExceptions.getDioException(err);
    }

    return CustomResponse(
      statusCode: err.response?.statusCode ?? 500,
      msg: msg,
    );
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
  final log = const Logger("");

  // String username = 'TestEnvironments';
  //
  // String username = 'ALJSecretkey';
  // String password = 'ZGF0YW9jZWFuQDIwMjI=';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    super.onRequest(options, handler);
    // bloc.add(GenerateTokenEvent());

    log.info("*" * 40);
    log.info("onRequest");
    options.headers.addAll({"Accept-Language": CacheHelper.lang});
    if (!["api/Authorization/PatientAuthentication"].contains(options.path)) {
      options.headers.addAll({"Authorization": 'Bearer ${CacheHelper.token}'});
    }

    log.info("(${options.method}) ( ${options.baseUrl}${options.path} )");
    if (options.data != null) {
      final data = options.data;

      if (data is FormData) {
        if (data.fields.isNotEmpty || data.files.isNotEmpty) {
          log.info("📦 FormData:");
          for (var field in data.fields) {
            log.info("${field.key}: ${field.value}");
          }
          for (var file in data.files) {
            log.info("🖼️ File: ${file.key} -> ${file.value.filename}");
          }
        }
      } else if (data is Map && data.isNotEmpty) {
        log.info("🧾 Data:");
        data.forEach((key, value) {
          log.info("$key: $value");
        });
      } else {
        log.info("📤 Data type: ${data.runtimeType}");
      }
    }

    if ((options.queryParameters).isNotEmpty) {
      log.info("Query Parameters :");
      options.queryParameters.forEach((key, value) {
        log.info("$key : $value");
      });
      log.info("-" * 20);
    }
    log.info("Headers:");
    options.headers.forEach((key, value) {
      log.info("$key : $value");
    });
    log.info("*" * 40);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log.error("onError");
    log.error(err);
    if (err.response?.statusCode == 401) {
      await CacheHelper.logOut();
      navigateTo(LoginView(), keepHistory: false);
    }
    return super.onError(err, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    log.fine("onResponse");
    var resp = jsonEncode(response.data);
    log.fine(resp);
    return super.onResponse(response, handler);
  }
}

abstract class NetworkExceptions {
  static String? handleResponse(Response response) {
    int statusCode = response.statusCode ?? 0;
    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        CacheHelper.logOut();
        navigateTo(LoginView(), keepHistory: false);
        return "Unauthorized request. Please log in again.";
      case 404:
        return "Requested resource not found.";
      case 204:
        return response.data?["message"] ?? "No Data";
      case 409:
        return "Error due to a conflict. Please try again later.";
      case 408:
        return "Connection request timeout. Please try again later.";
      case 500:
        return "Internal server error. Please try again later.";
      case 503:
        return "Service unavailable. Please try again later.";
      default:
        return null;
    }
  }

  static String getDioException(error) {
    if (error is Exception) {
      try {
        var errorMessage = "";
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorMessage = "Request cancelled.";
              //errorMessage = "Contact Administrator";
              break;
            case DioExceptionType.badCertificate:
              //errorMessage = "Contact Administrator";
              errorMessage = "Bad Certificate";
              break;
            case DioExceptionType.connectionError:
              errorMessage = "No internet connection";

              /// todo: if have screen

              //navigateTo(const NoInternetView(), keepHistory: false);
              break;
            case DioExceptionType.sendTimeout:
              //errorMessage = "Contact Administrator";
              errorMessage =
                  "Send timeout in connection with API server. Please try again later.";
              break;
            case DioExceptionType.receiveTimeout:
              //errorMessage = "Contact Administrator";
              errorMessage =
                  "Send timeout in connection with API server. Please try again later.";
              break;
            case DioExceptionType.connectionTimeout:
              // errorMessage = "Contact Administrator";
              errorMessage =
                  "Connection request timeout. Please try again later.";
              break;
            case DioExceptionType.badResponse:
              //errorMessage = "Contact Administrator";
              errorMessage =
                  NetworkExceptions.handleResponse(error.response!) ??
                  "Bad Response";
              break;

            default:
              errorMessage = "Un Known Error";
            //errorMessage = "Contact Administrator";
          }
        } else if (error is SocketException) {
          errorMessage = "No internet connection.";

          /// todo: if have screen
          // navigateTo(const NoInternetView());
        } else {
          // errorMessage = "Contact Administrator";
          errorMessage = "Unexpected error occurred. Please try again later.";
        }
        return errorMessage;
      } on FormatException {
        return "Unexpected error occurred. Please try again later.";
      } catch (_) {
        return "Unexpected error occurred. Please try again later.";
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return "Unable to process the data. Please try again later.";
      } else {
        return "Unexpected error occurred. Please try again later.";
      }
    }
  }
}
