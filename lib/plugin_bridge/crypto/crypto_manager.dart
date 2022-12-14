import 'dart:convert';
import 'dart:io';

import 'package:zpass/util/log_utils.dart';
import 'package:zpass_crypto/zpass_crypto.dart';
import 'package:sp_util/sp_util.dart';

import 'crypto_model.dart';

class CryptoManager {
  factory CryptoManager() => _instance;
  static final CryptoManager _instance = CryptoManager._internal();
  late final ZpassCrypto _crypto;
  String? _clientId;
  final String _tag = "CryptoManager";
  static const String _kSecretKey = "kZPassSecretKey";
  static const String _kLoginResponseKeys = "kLoginResponseKeys";
  late final Map<String, dynamic> _reqHeaders;

  CryptoManager._internal() {
    _crypto = ZpassCrypto();
    _reqHeaders = {
      "version": "1.0.0",
      "edition": Platform.isIOS
          ? "community-mobile-ios"
          : (Platform.isAndroid
              ? "community-mobile-android"
              : "community-mobile"),
      "authorization": "Bearer"
    };
  }

  String _newCryptoService() {
    final rep = _crypto.newCryptoService();
    if (rep == null) {
      Log.e("new crypto service fail: return is null", tag: _tag);
      return "";
    }
    final model = CryptoModel.fromJson(jsonDecode(rep));
    if (!model.isSuccess()) {
      Log.e("new crypto service fail:${model.msg}", tag: _tag);
      return "";
    }
    return model.data ?? "";
  }

  String? generateSecretKey() {
    // final String key = SpUtil.getString(_kSecretKey) ?? "";
    // if (key.isNotEmpty) {
    //   return Future.value(key);
    // }
    final rep = _crypto.generateSecretKey();
    if (rep == null) return null;
    final model = CryptoModel.fromJson(jsonDecode(rep));
    if (!model.isSuccess()) {
     Log.e("generate secret key fail:${model.msg}", tag: _tag);
     return null;
    }
    // SpUtil.putString(_kSecretKey, model.data);
    return model.data;
  }

  Future<String?> createUserKeyModel(String user, String password, String key) async {
    // final String key = SpUtil.getString(_kSecretKey) ?? "";
    if (key.isEmpty) return null;
    final rep = await _crypto.createUserKeyModel(identifierName: user, masterPassword: password, raw: key);
    if (rep == null) return null;
    final model = CryptoModel.fromJson(jsonDecode(rep));
    if (!model.isSuccess()) {
      Log.e("generate secret key fail:${model.msg}", tag: _tag);
      return null;
    }
    return model.data;
  }

  Future<dynamic> login(
    String user,
    String password,
    String host,
    String key,
    {Map<String, dynamic>? header, bool isPersonal = true,}
  ) async {
    if ((_clientId ?? "").isEmpty) {
     final cid = _newCryptoService();
     if (cid.isEmpty) {
       return Future.error("failed to generate clientId");
     }
     _clientId = cid;
    }
    final resp = await _crypto.login(
      clientId: _clientId!,
      identifierName: user,
      masterPassword: password,
      secretKey: key.toUpperCase(),
      host: host,
      headerJson: jsonEncode(header ?? _reqHeaders),
      isPersonal: isPersonal,
    );
    if (resp == null) return Future.error("login fail, response is null");
    final model = CryptoModel.fromJson(jsonDecode(resp));
    if (!model.isSuccess()) {
      Log.e("login fail:${model.msg}", tag: _tag);
      return Future.error("login fail:${model.msg}");
    }
    SpUtil.putString(_kLoginResponseKeys, model.data);
    final result = jsonDecode(model.data);
    return jsonDecode(model.data);
  }

  Future<dynamic> offlineLogin(
      String user,
      String masterKey,
      String masterKeyHash,
      String personalDataKey,
      String enterpriseDataKey,
      {bool isPersonal = true}
      ) {
    if ((_clientId ?? "").isEmpty) {
      final cid = _newCryptoService();
      if (cid.isEmpty) {
        return Future.error("failed to generate clientId");
      }
      _clientId = cid;
    }
    // final userKeys = SpUtil.getString(_kLoginResponseKeys) ?? "";
    // if (userKeys.isEmpty) return Future.error("user key is empty");
    // final data = jsonDecode(userKeys);
    final resp = _crypto.offlineLogin(
      clientId: _clientId!,
      identifierName: user,
      masterKey: masterKey,
      masterKeyHash: masterKeyHash,
      isPersonal: isPersonal,
      personalDataKey: personalDataKey,
      enterpriseDataKey: enterpriseDataKey,
    );
    if (resp == null) return Future.error("offline login fail, response is null");
    final model = CryptoModel.fromJson(jsonDecode(resp));
    if (!model.isSuccess()) {
      Log.e("offline login fail:${model.msg}", tag: _tag);
      return Future.error("login fail:${model.msg}");
    }
    return Future.value(model.data);
  }

  bool destroy() {
    final resp = _crypto.destroy(clientId: _clientId ?? "");
    final model = CryptoModel.fromJson(jsonDecode(resp ?? ""));
    _clientId = "";
    return model.isSuccess();
  }

  Future<String> encryptText({required String text, bool isPersonal = true,}) {
    if ((_clientId ?? "").isEmpty) {
      final cid = _newCryptoService();
      if (cid.isEmpty) return Future.error("failed to generate clientId");
      _clientId = cid;
    }
    final resp = _crypto.encryptText(clientId: _clientId!, plaintext: text, isPersonal: isPersonal);
    if (resp == null) return Future.error("encrypt text fail, response is null");
    final model = CryptoModel.fromJson(jsonDecode(resp));
    if (!model.isSuccess()) {
      Log.e("encrypt text fail:${model.msg}", tag: _tag);
      return Future.error("encrypt text fail:${model.msg}");
    }
    return Future.value(model.data);
  }

  Future<String> decryptText({required String text, bool isPersonal = true,}) {
    if ((_clientId ?? "").isEmpty) {
      final cid = _newCryptoService();
      if (cid.isEmpty) return Future.error("failed to generate clientId");
      _clientId = cid;
    }
    final resp = _crypto.decryptText(clientId: _clientId!, cipherText: text, isPersonal: isPersonal);
    if (resp == null) return Future.error("decrypt text fail, response is null");
    final model = CryptoModel.fromJson(jsonDecode(resp));
    if (!model.isSuccess()) {
      Log.e("decrypt text fail:${model.msg}", tag: _tag);
      return Future.error("decrypt text fail:${model.msg}");
    }
    return Future.value(model.data);
  }

  String? calcPasswordHash(
      {required String user,
        required String password,
        required String secretKey,
        dynamic hint}) {
    final resp = _crypto.calcPasswordHash(
      identifierName: user,
      masterPassword: password,
      secretKey: secretKey,
    );
    if (resp == null) return null;
    final model = CryptoModel.fromJson(jsonDecode(resp));
    if (!model.isSuccess()) {
      Log.e("calcPasswordHash fail:${model.msg}", tag: _tag);
      return null;
    }
    return model.data;
  }

}