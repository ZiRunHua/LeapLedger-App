import 'dart:collection';
import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/current.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/account.dart';
import 'package:keepaccount_app/model/product/model.dart';

import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/util/json.dart';

part 'user.dart';
part 'account.dart';
part 'transaction_category.dart';
part 'product.dart';

enum Method {
  post,
  get,
  put,
  delete,
}

class ApiServer {
  static Dio dio = Dio(BaseOptions(
    baseUrl: Global.config.server.network.address,
    receiveTimeout: const Duration(seconds: 5),
    connectTimeout: const Duration(seconds: 5),
    headers: {'Content-Type': 'application/json', 'User-Agent': Current.peratingSystem},
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers[HttpHeaders.authorizationHeader] = UserBloc.token;
        return handler.next(options); // 必须调用 next 方法，否则请求不会继续
      },
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
      print(e.response);
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
    print({method, path, data});
    Response? response = await _issueRequest(method, path, data, options);
    //处理响应
    if (response == null || response.statusCode == null) {
      throw getResponseBodyAndShowError(null, errorMsg: "服务器错误");
    }
    int code = response.statusCode!;
    if (code >= 200 && code < 300) {
      return ResponseBody(response.data);
    } else if (code == 401) {
      if (Global.navigatorKey.currentState != null) {
        bool isShowOverlayLoader = Global.isShowOverlayLoader();
        if (isShowOverlayLoader) {
          Global.hideOverlayLoader();
        }
        return await Global.navigatorKey.currentState!.pushNamed(Routes.login).then((value) {
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
      responseBody = ResponseBody({'msg': response.data}, isSuccess: false);
    } else {
      responseBody = ResponseBody(response.data, isSuccess: false);
    }
    Global.toast.error(message: errorMsg ?? responseBody.msg);
    print({"error", response});
    return responseBody;
  }
}

class ResponseBody {
  late String msg;
  late Map<String, dynamic> data;
  late bool isSuccess;
  ResponseBody(Map<String, dynamic>? body, {this.isSuccess = true}) {
    print(body);
    if (body != null) {
      msg = body['msg'] ?? '';
      if (body is String) {
        msg = body as String;
        data = {};
      } else if (body['data'] is Map<String, dynamic>) {
        data = body['data'];
      } else {
        msg = body['msg'] ?? body['data'] as String;
        data = {};
      }
    } else {
      msg = '';
      data = {};
    }
  }
}
