import 'dart:convert';

import 'package:zpass/base/crypto/crypto_model.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass_crypto/zpass_crypto.dart';
import 'package:sp_util/sp_util.dart';

class CryptoManager {
  late final ZpassCrypto _crypto;
  factory CryptoManager() => _instance;
  static final CryptoManager _instance = CryptoManager._internal();
  String? _clientId;
  final String _tag = "CryptoManager";
  static const String _kSecretKey = "kZPassSecretKey";
  static const String _kLoginResponseKeys = "kLoginResponseKeys";

  CryptoManager._internal() {
    _crypto = ZpassCrypto();
    _newCryptoService();
  }

  void _newCryptoService() async {
    final rep = await _crypto.newCryptoService();
    if (rep == null) {
      Log.e("new crypto service fail: return is null", tag: _tag);
      return;
    }
    final model = CryptoModel.fromJson(jsonDecode(rep));
    if (!model.isSuccess()) {
      Log.e("new crypto service fail:${model.msg}", tag: _tag);
      return;
    }
    _clientId = model.data ?? "";
  }

  Future<String?> generateSecretKey() async {
    final String key = SpUtil.getString(_kSecretKey) ?? "";
    if (key.isNotEmpty) {
      return Future.value(key);
    }
    final rep = await _crypto.generateSecretKey();
    if (rep == null) return null;
    final model = CryptoModel.fromJson(jsonDecode(rep));
    if (!model.isSuccess()) {
     Log.e("generate secret key fail:${model.msg}", tag: _tag);
     return null;
    }
    SpUtil.putString(_kSecretKey, model.data);
    return model.data;
  }

  Future<String?> createUserKeyModel(String user, String password, ) async {
    final String key = SpUtil.getString(_kSecretKey) ?? "";
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
    Map<String, dynamic> header,
    bool isPersonal,
  ) async {
    if ((_clientId ?? "").isEmpty) return Future.value(null);
    final String key = SpUtil.getString(_kSecretKey) ?? "";
    if (key.isEmpty) return Future.value(null);
    final resp = await _crypto.login(
      clientId: _clientId!,
      identifierName: user,
      masterPassword: password,
      secretKey: key,
      host: host,
      headerJson: jsonEncode(header),
      isPersonal: isPersonal,
    );
    if (resp == null) return Future.value(null);
    final model = CryptoModel.fromJson(jsonDecode(resp));
    if (!model.isSuccess()) {
      Log.e("login fail:${model.msg}", tag: _tag);
      return null;
    }
    SpUtil.putString(_kLoginResponseKeys, model.data);
    return jsonDecode(model.data);
  }

  Future<dynamic> offlineLogin(
      String user,
      String password,
      bool isPersonal,
      ) async {
    if ((_clientId ?? "").isEmpty) return Future.value(null);
    final String key = SpUtil.getString(_kSecretKey) ?? "";
    if (key.isEmpty) return Future.value(null);
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
    if (resp == null) return Future.value(null);
    final model = CryptoModel.fromJson(jsonDecode(resp));
    if (!model.isSuccess()) {
      Log.e("offline login fail:${model.msg}", tag: _tag);
      return null;
    }
    SpUtil.putString(_kLoginResponseKeys, model.data);
    return jsonDecode(model.data);
  }

  Future<bool> destroy() async {
    final resp = await _crypto.destroy(clientId: _clientId ?? "");
    final model = CryptoModel.fromJson(jsonDecode(resp ?? ""));
    return model.isSuccess();
  }

}