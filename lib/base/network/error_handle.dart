import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ExceptionHandle {
  static const int success = 200;
  static const int successNoContent = 204;
  static const int notModified = 304;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;

  static const int netError = 1000;
  static const int parseError = 1001;
  static const int socketError = 1002;
  static const int httpError = 1003;
  static const int connectTimeoutError = 1004;
  static const int sendTimeoutError = 1005;
  static const int receiveTimeoutError = 1006;
  static const int cancelError = 1007;
  static const int unknownError = 9999;

  static final Map<int, NetError> _errorMap = <int, NetError>{
    netError             :   NetError(netError, 'Network error'),
    parseError           :   NetError(parseError, 'Parse data error'),
    socketError          :   NetError(socketError, 'Network error'),
    httpError            :   NetError(httpError, 'Server error, try again.'),
    connectTimeoutError  :   NetError(connectTimeoutError, 'Connect timeout'),
    sendTimeoutError     :   NetError(sendTimeoutError, 'Request timeout'),
    receiveTimeoutError  :   NetError(receiveTimeoutError, 'Receive timeout'),
    cancelError          :   NetError(cancelError, 'Request canceled'),
    unknownError         :   NetError(unknownError, 'Unknown error'),
  };

  static NetError handleException(dynamic error) {
    debugPrint(error.toString());
    if (error is DioError) {
      if (error.type.errorCode == 0) {
        return _handleException(error.error);
      } else {
        return _errorMap[error.type.errorCode]!;
      }
    } else {
      return _handleException(error);
    }
  }

  static NetError _handleException(dynamic error) {
    int errorCode = unknownError;
    if (error is SocketException) {
      errorCode = socketError;
    }
    if (error is HttpException) {
      errorCode = httpError;
    }
    if (error is FormatException) {
      errorCode = parseError;
    }
    return _errorMap[errorCode]!;
  }
}

class NetError{

  NetError(this.code, this.msg);

  int code;
  String msg;
}

extension DioErrorTypeExtension on DioErrorType {
  int get errorCode => [
    ExceptionHandle.connectTimeoutError,
    ExceptionHandle.sendTimeoutError,
    ExceptionHandle.receiveTimeoutError,
    0,
    ExceptionHandle.cancelError,
    0,
  ][index];
}
