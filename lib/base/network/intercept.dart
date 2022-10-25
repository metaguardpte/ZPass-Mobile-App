
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sprintf/sprintf.dart';
import 'package:zpass/base/network/error_handle.dart';
import 'package:zpass/base/network/httpclient.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/res/constant.dart';
import 'package:zpass/util/device_utils.dart';
import 'package:zpass/util/log_utils.dart';


class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String accessToken = UserProvider().userInfo.userCryptoKey?.token ?? "";
    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    // if (!Device.isWeb) {
    //   // https://developer.github.com/v3/#user-agent-required
    //   options.headers['User-Agent'] = 'Mozilla/5.0';
    // }
    super.onRequest(options, handler);
  }
}

class TokenInterceptor extends QueuedInterceptor {

  Dio? _tokenDio;

  Future<String?> getToken() async {

    final Map<String, String> params = <String, String>{};
    params['refresh_token'] = SpUtil.getString(Constant.refreshToken) ?? "";
    try {
      _tokenDio ??= Dio();
      _tokenDio!.options = HttpClient.instance.options;
      final Response<dynamic> response = await _tokenDio!.post<dynamic>('lgn/refreshToken', data: params);
      if (response.statusCode == ExceptionHandle.success) {
        return (json.decode(response.data.toString()) as Map<String, dynamic>)['access_token'] as String;
      }
    } catch(e) {
      Log.e('刷新Token失败！');
    }
    return null;
  }

  @override
  Future<void> onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) async {
    //401代表token过期
    if (response.statusCode == ExceptionHandle.unauthorized) {
      Log.d('-----------自动刷新Token------------');
      final String? accessToken = await getToken(); // 获取新的accessToken
      Log.e('-----------NewToken: $accessToken ------------');
      SpUtil.putString(Constant.accessToken, accessToken ?? "");

      if (accessToken != null) {
        // 重新请求失败接口
        final RequestOptions request = response.requestOptions;
        request.headers['Authorization'] = 'Bearer $accessToken';

        final Options options = Options(
          headers: request.headers,
          method: request.method,
        );

        try {
          Log.e('----------- 重新请求接口 ------------');
          /// 避免重复执行拦截器，使用tokenDio
          final Response<dynamic> response = await _tokenDio!.request<dynamic>(request.path,
            data: request.data,
            queryParameters: request.queryParameters,
            cancelToken: request.cancelToken,
            options: options,
            onReceiveProgress: request.onReceiveProgress,
          );
          return handler.next(response);
        } on DioError catch (e) {
          return handler.reject(e);
        }
      }
    }
    super.onResponse(response, handler);
  }
}

class LoggingInterceptor extends Interceptor{

  late DateTime _startTime;
  late DateTime _endTime;
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTime = DateTime.now();
    Log.d('----------Start----------');
    if (options.queryParameters.isEmpty) {
      Log.d('RequestUrl: ${options.baseUrl}${options.path}');
    } else {
      Log.d('RequestUrl: ${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}');
    }
    Log.d('RequestMethod: ${options.method}');
    Log.d('RequestHeaders:${options.headers}');
    Log.d('RequestContentType: ${options.contentType}');
    Log.d('RequestData: ${options.data.toString()}');
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success) {
      Log.d('ResponseCode: ${response.statusCode}');
    } else {
      Log.e('ResponseCode: ${response.statusCode}');
    }
    // 输出结果
    Log.json(response.data.toString());
    Log.d('----------End: $duration 毫秒----------');
    super.onResponse(response, handler);
  }
  
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Log.d('----------Error-----------');
    super.onError(err, handler);
  }
}

///
/// 转换成Restful API风格的Response
///
class AdapterInterceptor extends Interceptor{

  static const String _respFormat = '{"code":%d,"message":"","data":%s}';
  
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final Response<dynamic> r = adapterData(response);
    super.onResponse(r, handler);
  }
  
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      adapterData(err.response!);
    }
    super.onError(err, handler);
  }

  Response<dynamic> adapterData(Response<dynamic> response) {
    String result;
    String content = response.data?.toString() ?? '';
    if (response.statusCode == ExceptionHandle.success ||
        response.statusCode == ExceptionHandle.successNoContent) {
      /// 成功时，直接格式化返回
      if (content.isEmpty) {
        content = "{}";
      }
      result = sprintf(_respFormat, [ExceptionHandle.success, content]);
      response.statusCode = ExceptionHandle.success;
    } else {
      if (content.isEmpty) {
        content = "{}";
      }

      /// 错误数据格式化后返回
      result = sprintf(_respFormat, [response.statusCode, content]);
    }
    response.data = result;
    return response;
  }
}
