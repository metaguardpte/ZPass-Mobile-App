import 'dart:convert';

import 'package:zpass/util/log_utils.dart';
import 'package:zpass_crypto/zpass_crypto.dart';
import 'package:sp_util/sp_util.dart';

import 'crypto_model.dart';

class CryptoManager {
  late final ZpassCrypto _crypto;
  static CryptoManager get instance => CryptoManager._internal();
  String? _clientId;
  final String _tag = "CryptoManager";
  static const String _kSecretKey = "kZPassSecretKey";
  static const String _kLoginResponseKeys = "kLoginResponseKeys";

  factory CryptoManager() {
    return instance;
  }

  CryptoManager._internal() {
    _crypto = ZpassCrypto();
  }

  Future<String> _newCryptoService() async {
    final rep = await _crypto.newCryptoService();
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

  Future<String?> generateSecretKey() async {
    // final String key = SpUtil.getString(_kSecretKey) ?? "";
    // if (key.isNotEmpty) {
    //   return Future.value(key);
    // }
    final rep = await _crypto.generateSecretKey();
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
    Map<String, dynamic> header,
    bool isPersonal,
  ) async {
    if ((_clientId ?? "").isEmpty) {
     final cid = await _newCryptoService();
     if (cid.isEmpty) {
       return Future.error("failed to generate clientId");
     }
     _clientId = cid;
    }
    final resp = await _crypto.login(
      clientId: _clientId!,
      identifierName: user,
      masterPassword: password,
      secretKey: key,
      host: host,
      headerJson: jsonEncode(header),
      isPersonal: isPersonal,
    );
    if (resp == null) return Future.error("login fail, response is null");
    final model = CryptoModel.fromJson(jsonDecode(resp));
    if (!model.isSuccess()) {
      Log.e("login fail:${model.msg}", tag: _tag);
      return Future.error("login fail:${model.msg}");
    }
    SpUtil.putString(_kLoginResponseKeys, model.data);
    return jsonDecode(model.data);
  }

  Future<dynamic> offlineLogin(
      String user,
      String password,
      String key,
      bool isPersonal,
      ) async {
    if ((_clientId ?? "").isEmpty) {
      final cid = await _newCryptoService();
      if (cid.isEmpty) {
        return Future.error("failed to generate clientId");
      }
      _clientId = cid;
    }
    final userKeys = SpUtil.getString(_kLoginResponseKeys) ?? "";
    if (userKeys.isEmpty) return Future.value(null);
    final data = jsonDecode(userKeys);
    final resp = await _crypto.offlineLogin(
      clientId: _clientId!,
      identifierName: user,
      masterPassword: password,
      secretKey: key,
      isPersonal: isPersonal,
      masterKeyHash: data["masterKeyHash"] ?? "",
      personalDataKey: data["personalDataKey"] ?? "",
      enterpriseDataKey: data["enterpriseDataKey"] ?? "",
    );
    if (resp == null) return Future.error("login fail, response is null");
    final model = CryptoModel.fromJson(jsonDecode(resp));
    if (!model.isSuccess()) {
      Log.e("offline login fail:${model.msg}", tag: _tag);
      return Future.error("login fail:${model.msg}");
    }
    SpUtil.putString(_kLoginResponseKeys, model.data);
    return jsonDecode(model.data);
  }

  Future<bool> destroy() async {
    final resp = await _crypto.destroy(clientId: _clientId ?? "");
    final model = CryptoModel.fromJson(jsonDecode(resp ?? ""));
    _clientId = "";
    return model.isSuccess();
  }

}