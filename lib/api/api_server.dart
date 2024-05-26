import 'dart:collection';
import 'dart:core';
import 'dart:io';
import 'package:keepaccount_app/model/common/model.dart';
import 'package:uuid/uuid.dart';

import 'package:dio/dio.dart'
    show
        BaseOptions,
        Dio,
        DioException,
        FormData,
        InterceptorsWrapper,
        LogInterceptor,
        MultipartFile,
        Options,
        QueuedInterceptor,
        RequestOptions,
        Response;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';

import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/current.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';

import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/model/user/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/util/enter.dart';
import 'package:keepaccount_app/widget/toast.dart';

part 'common.dart';
part 'user.dart';
part 'account.dart';
part 'transaction_category.dart';
part 'transaction.dart';
part 'product.dart';

enum Method {
  post,
  get,
  put,
  delete,
}

const String pubilcBaseUrl = '/public';

class ApiServer {
  static const _uuid = Uuid();
  static Dio dio = Dio(BaseOptions(
    baseUrl: Global.config.server.network.address,
    headers: {'Content-Type': 'application/json', 'User-Agent': Current.peratingSystem},
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers[HttpHeaders.authorizationHeader] = UserBloc.token;
        return handler.next(options);
      },
    ))
    ..interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          maxStale: const Duration(days: 7),
          keyBuilder: (RequestOptions request) {
            return _uuid.v5(Uuid.NAMESPACE_URL, request.uri.toString() + request.data.toString());
          },
          store: HiveCacheStore(Global.tempDirectory.path),
          policy: CachePolicy.request,
        ),
      ),
    )
    ..interceptors.add(QueuedInterceptor())
    ..interceptors.add(LogInterceptor(
      request: true,
      requestHeader: false,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  static Future<Response?> _issueRequest(Method method, String path, Object? data, Options options) async {
    Response response;
    try {
      switch (method) {
        case Method.get:
          response = await dio.get(path, data: data, options: options);

        case Method.post:
          response = await dio.post(path, data: data, options: options);

        case Method.put:
          response = await dio.put(path, data: data, options: options);

        case Method.delete:
          response = await dio.delete(path, data: data, options: options);
      }
    } on DioException catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
    return response;
  }

  static getData(Future<ResponseBody> Function() requestFunc, Function(ResponseBody) dataFormatFunc) async {
    ResponseBody response = await requestFunc();
    return dataFormatFunc(response);
  }

  static Future<ResponseBody> request(Method method, String path, {Object? data, Map<String, dynamic>? header}) async {
    Options options = Options(headers: header ?? {});
    Response? response = await _issueRequest(method, path, data, options);
    //处理响应
    if (response == null || response.statusCode == null) {
      return getResponseBodyAndShowError(null, errorMsg: "服务器错误");
    }
    int code = response.statusCode!;
    if (code >= 200 && (code < 300 || code == 304)) {
      return ResponseBody(response.data);
    } else if (code == 401) {
      if (Global.navigatorKey.currentState != null) {
        bool isShowOverlayLoader = Global.isShowOverlayLoader();
        if (isShowOverlayLoader) {
          Global.hideOverlayLoader();
        }
        return await Global.navigatorKey.currentState!.pushNamed(UserRoutes.login).then((value) {
          if (isShowOverlayLoader) {
            Global.showOverlayLoader();
          }
          if (value == true) {
            return request(method, path, data: data, header: header);
          }
          return getResponseBodyAndShowError(null, errorMsg: "未登录");
        });
      }
      return getResponseBodyAndShowError(null, errorMsg: "未登录");
    }
    return getResponseBodyAndShowError(response);
  }

  static ResponseBody getResponseBodyAndShowError(Response? response, {String? errorMsg}) {
    ResponseBody responseBody;
    if (response == null) {
      responseBody = ResponseBody(null, isSuccess: false);
    } else if (response.data is String) {
      responseBody = ResponseBody({'Msg': response.data}, isSuccess: false);
    } else {
      responseBody = ResponseBody(response.data, isSuccess: false);
    }
    Toast.error(message: errorMsg ?? responseBody.msg);
    return responseBody;
  }
}

class ResponseBody {
  late String msg;
  late Map<String, dynamic> data;
  late bool isSuccess;
  ResponseBody(dynamic body, {this.isSuccess = true}) {
    if (body != null) {
      if (body is Map<String, dynamic>) {
        msg = body['Msg'] ?? '';
        if (body is String) {
          msg = body as String;
          data = {};
        } else if (body['Data'] is Map<String, dynamic>) {
          data = body['Data'];
        } else {
          msg = body['Msg'] ?? body['Data'] as String;
          data = {};
        }
      } else {
        msg = body;
        data = {};
      }
    } else {
      msg = '';
      data = {};
    }
  }
}
