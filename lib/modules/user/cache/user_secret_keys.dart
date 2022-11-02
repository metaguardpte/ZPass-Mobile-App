import 'dart:convert';

import 'package:zpass/modules/user/cache/user_storage.dart';

///
/// cache email & secretKey for users who has login successfully once
///
class UserSecretKeys with UserStorage {
  static const String _kSignInList = 'zpass-mobile-signInList';

  late Map<String , dynamic> _loginUserList;

  @override
  Future<dynamic> restore() async {
    final signInList = await read(_kSignInList);
    if (signInList != null && signInList != '') {
      _loginUserList = jsonDecode(signInList);
    } else{
      _loginUserList = {};
    }
  }

  @override
  Future<dynamic> flush() {
    return write(_kSignInList, jsonEncode(_loginUserList));
  }

  @override
  Future<dynamic> clear() {
    // do NOT clean users' email-secretKey cache
    return Future.value();
  }

  void save({required String email, required String secretKey}) {
    _loginUserList[email] = secretKey;
    flush();
  }


  String? get({required String email}) => _loginUserList[email];
}