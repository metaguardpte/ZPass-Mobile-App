import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zpass/base/network/base_resp.dart';
import 'package:zpass/base/network/error_handle.dart';
import 'package:zpass/res/constant.dart';

/// default config for Dio
int _connectTimeout = 15000;
int _receiveTimeout = 15000;
int _sendTimeout = 10000;
String _baseUrl = '';
List<Interceptor> _interceptors = [];

/// config Dio
void configDio({
  int? connectTimeout,
  int? receiveTimeout,
  int? sendTimeout,
  String? baseUrl,
  List<Interceptor>? interceptors,
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _interceptors = interceptors ?? _interceptors;
}

class HttpClient {

  factory HttpClient() => _singleton;

  HttpClient._() {
    final BaseOptions options = BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
      /// Response type: Plain
      responseType: ResponseType.plain,
      validateStatus: (_) {
        // Validate status for REST in AdapterInterceptor
        return true;
      },
      baseUrl: _baseUrl,
//      contentType: Headers.formUrlEncodedContentType, // For post form
    );
    _dio = Dio(options);
    /// Fiddler proxy https://www.jianshu.com/p/d831b1f7c45b
//    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//        (HttpClient client) {
//      client.findProxy = (uri) {
//        //proxy all request to localhost:8888
//        return 'PROXY 10.41.0.132:8888';
//      };
//      client.badCertificateCallback =
//          (X509Certificate cert, String host, int port) => true;
//    };

    /// add interceptors
    void addInterceptor(Interceptor interceptor) {
      _dio.interceptors.add(interceptor);
    }
    _interceptors.forEach(addInterceptor);
  }

  static final HttpClient _singleton = HttpClient._();

  static HttpClient get instance => HttpClient();

  static late Dio _dio;

  BaseOptions get options => _dio.options;

  Future<BaseResp> _request(String method, String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final Response<String> response = await _dio.request<String>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,
    );
    try {
      final String data = response.data.toString();
      /// isolate can NOT be used in Integration Testing https://github.com/flutter/flutter/issues/24703
      /// compute limitations：data large than 10KB and not in Integration Testing
      /// Reduce performance overhead
      final bool isCompute = !Constant.isDriverTest && data.length > 10 * 1024;
      debugPrint('isCompute:$isCompute');
      final Map<String, dynamic> map = isCompute ? await compute(_parseData, data) : _parseData(data);
      return BaseResp.fromJson(map);
    } catch(e) {
      debugPrint(e.toString());
      return BaseResp(code: ExceptionHandle.parseError, message: "data parse error", data: null);
    }
  }

  Options _checkOptions(String method, Options? options) {
    options ??= Options();
    options.method = method;
    return options;
  }

  Future<BaseResp> requestNetwork(Method method, String url, {
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _request(method.value, url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    ).catchError((e) => throw ExceptionHandle.handleException(e));
  }
}

Map<String, dynamic> _parseData(String data) {
  return json.decode(data) as Map<String, dynamic>;
}

enum Method {
  get,
  post,
  put,
  patch,
  delete,
  head
}

extension MethodExtension on Method {
  String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}
