import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zpass/base/app_config.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/scanner/router_scanner.dart';
import 'package:zpass/modules/sync/sync_task.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/plugin_bridge/crypto/crypto_manager.dart';
import 'package:zpass/plugin_bridge/local_auth/local_auth_manager.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/routers/routers.dart';
import 'package:zpass/util/device_utils.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/dialog/zpass_loading_dialog.dart';
import 'package:zpass/widgets/zpass_button_gradient.dart';
import 'package:zpass/widgets/zpass_form_edittext.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key, this.data}) : super(key: key);
  final String? data;

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  late final loadingDialog = ZPassLoadingDialog();
  FocusNode focusNode = FocusNode();
  Widget _biometricsButton = Gaps.empty;

  final _emailKey = GlobalKey<ZPassFormEditTextState>();
  final _passwordKey = GlobalKey<ZPassFormEditTextState>();
  final _secretGlobalKey = GlobalKey<ZPassFormEditTextState>();

  String _secretKey = "";
  String _password = "";
  String _email = "";

  String recode(String code) {
    if (code.length < 9) return code;
    var str = code.substring(0, 8);
    return '$str **** **** ****';
  }

  void _handleSignIn() {
    if (_email.isEmpty) {
      Toast.showError(S.current.signinTip + S.current.email);
      return;
    } else if (_password.isEmpty) {
      Toast.showError(S.current.signinTip + S.current.password);
      return;
    } else if (_secretKey.isEmpty) {
      Toast.showError(S.current.signinTip + S.current.seKey);
      return;
    }
    loadingDialog.show(context, barrierDismissible: false);
    CryptoManager()
        .login(_email, _password, AppConfig.serverUrl, _secretKey)
        .then(_loginSuccess)
        .catchError((error) {
      loadingDialog.dismiss(context);
      Toast.showSpec(S.current.loginFail);
    });
    //submit
  }

  _loginSuccess(value) {
    UserProvider().secretKeys.save(email: _email, secretKey: _secretKey);
    UserProvider().profile.setMainUser(_email);
    UserProvider().profile.userCryptoKey = UserCryptoKeyModel.fromJson(value);
    UserProvider().profile.userSecretKey = _secretKey;
    UserProvider().biometrics.putUserLastLoginTime(DateTime.now(), _email);
    UserProvider().profile.tryUpdate().catchError((e) {
      Log.e("tryUpdate user profile failed: $e");
    }).whenComplete(() {
      SyncTask.run();
      loadingDialog.dismiss(context);
      NavigatorUtils.push(context, Routers.home, clearStack: true);
    });
  }

  _getEmail(value) {
    _email = value;
    _secretKey = '';
    _secretGlobalKey.currentState?.fillText("");
    if (_email.isEmpty) {
      _buildUserBiometricsBtn();
    }
  }

  _getPassword(value) {
    _password = value;
  }

  _getSecretKey(value) {
    _secretKey = value;
  }

  _getQRCode() {
    Permission.camera.request().then((status) {
      if (!status.isGranted) {
        Toast.showError(
            'No Camera Permission , Please go to the system settings to open the permission');
        return;
      }
      NavigatorUtils.pushResult(context, RouterScanner.scanner, _parseScanCodeResult);
    });
  }

  _parseScanCodeResult(dynamic data) {
    try {
      final params = Uri.parse(data['data']).queryParameters;
      final key = params['secretKey'] ?? "";
      if (key.isNotEmpty) {
        _secretKey = key;
        _secretGlobalKey.currentState?.fillText(key);
        final email = params['email'] ?? "";
        _email = email;
        _emailKey.currentState?.fillText(email);
        _buildUserBiometricsBtn();
      } else {
        Toast.showSpec('don`t get Secret Key');
      }
    } catch (e) {
      Log.d(e.toString());
      Toast.showSpec('don`t get Secret Key');
    }
  }

  void _initDefaultValue() {
    final userinfo = UserProvider().profile.getMainUser();
    if ((userinfo?.email ?? "").isEmpty) return;
    _email = userinfo?.email ?? "";
    _secretKey = userinfo?.secretKey ?? "";
  }

  bool _canAutomaticAuthenticate() {
    if ((widget.data ?? "").isEmpty) return false;
    final param = jsonDecode(widget.data!);
    return param["canAuth"] ?? false;
  }

  Future<bool> _canAuthenticate() async {
    if (!UserProvider().biometrics.getUserBiometrics(_email)) return false;
    return await LocalAuthManager().canAuth();
  }

  void _checkLocalAuth() async {
    final canAuth = await _canAuthenticate();
    if (canAuth) {
      if (!_canAutomaticAuthenticate()) return;
      _doAuthenticate();
    }
  }

  void _doAuthenticate() async {
    final isExpired = UserProvider().biometrics.checkBiometricsIsExpired(_email);
    if (isExpired) {
      int day = UserProvider().biometrics.getRequirePasswordDay(_email);
      Toast.showSpec(S.current.requirePasswordToLoginMessage(day));
      return;
    }
    final authResult = await LocalAuthManager().authenticate();
    Log.d("local auth result is:$authResult");
    if (!authResult) return;
    _doOfflineLogin();
  }

  void _doOfflineLogin() {
    final userInfo = UserProvider().profile.getMainUser(email: _email);
    if (userInfo == null) return;
    CryptoManager().offlineLogin(
      userInfo.email ?? "",
      userInfo.userCryptoKey?.masterKeyExported ?? "",
      userInfo.userCryptoKey?.masterKeyHash ?? "",
      userInfo.userCryptoKey?.personalDataKey ?? "",
      userInfo.userCryptoKey?.enterpriseDataKey ?? "",
    ).then((value) {
      UserProvider().profile.setMainUser(_email);
      SyncTask.run();
      NavigatorUtils.push(context, Routers.home, clearStack: true);
    }).catchError((error) {
      Toast.showSpec(S.current.loginFail);
    });
  }

  void _fillSecretKey() {
    final key = UserProvider().secretKeys.get(email: _email);
    _buildUserBiometricsBtn();

    if (key != null) {
      _secretKey = key;
      _secretGlobalKey.currentState?.fillText(recode(key));
    }
  }

  @override
  void initState() {
    super.initState();
    _initDefaultValue();
    _buildUserBiometricsBtn();
    _checkLocalAuth();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Column(
      children: [
        ZPassFormEditText(
          key: _emailKey,
          initialText: _email,
          hintText: S.current.email,
          filled: true,
          prefix: const Icon(ZPassIcons.icEmail, color: Color(0xFF959BA7), size: 20),
          onChanged: _getEmail,
          onUnFocus: _fillSecretKey,
        ),
        Gaps.vGap18,
        ZPassFormEditText(
          key: _passwordKey,
          hintText: S.current.password,
          filled: true,
          obscureText: true,
          prefix: const Icon(ZPassIcons.icLock, color: Color(0xFF959BA7), size: 20),
          onChanged: _getPassword,
        ),
        Gaps.vGap18,
        ZPassFormEditText(
          key: _secretGlobalKey,
          initialText: recode(_secretKey),
          hintText: S.current.seKey,
          filled: true,
          prefix: const Icon(ZPassIcons.icSignInSecretKey, color: Color(0xFF959BA7), size: 20),
          onChanged: _getSecretKey,
        ),
        Gaps.vGap24,
        _buildSignInBtn(),
        _buildDivider(),
        _buildScanCodeBtn(),
      ],
    );
  }

  Widget _buildSignInBtn() {
    return GestureDetector(
        onTap: _handleSignIn,
        child: Stack(
          children: [
            ZPassButtonGradient(
              text: S.current.login,
              height: 46,
              borderRadius: 23,
              startColor: const Color.fromRGBO(82, 115, 254, 1),
              endColor: const Color.fromRGBO(67, 66, 255, 1),
            ),
            _biometricsButton
          ],
        ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 0.5,
            color: const Color.fromRGBO(149, 155, 167, 0.42),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              S.current.or,
              style: const TextStyle(color: Color.fromRGBO(149, 155, 167, 1)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildScanCodeBtn() {
    return GestureDetector(
      onTap: _getQRCode,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        alignment: Alignment.center,
        width: 327,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                width: 1, color: const Color.fromRGBO(73, 84, 255, 1)),
            borderRadius: const BorderRadius.all(Radius.circular(23))),
        // color: ,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                    width: 30,
                    child: Icon(
                      ZPassIcons.icQrScan,
                      size: 16,
                      color: Color.fromRGBO(73, 84, 255, 1),
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    S.current.siginScan,
                    style: const TextStyle(
                      color: Color.fromRGBO(73, 84, 255, 1),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _buildUserBiometricsBtn() async {
    final canAuth = await _canAuthenticate();
    IconData icon = await _fetchBiometricsBtnIcon();
    Widget biometricsBtn = Positioned(
      right: 10,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 0.5,
            height: 20,
            color: const Color.fromRGBO(255, 255, 255, 0.28),
          ),
          Gaps.hGap5,
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _doAuthenticate,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 24, color: Colors.white,),
            ),
          )
        ],
      ),
    );
    _biometricsButton = canAuth ? biometricsBtn : Gaps.empty;
   setState(() {});
  }

  Future<IconData> _fetchBiometricsBtnIcon() async {
    final isExpired = UserProvider().biometrics.checkBiometricsIsExpired(_email);
    if (Device.isAndroid) return isExpired ? ZPassIcons.icBiometricsWarn : ZPassIcons.icBiometrics;
    final bool isSupportedFacID = await LocalAuthManager().isSupportedFaceID();
    return isSupportedFacID
        ? (isExpired ? ZPassIcons.icFaceIDWarn : ZPassIcons.icFaceID)
        : (isExpired ? ZPassIcons.icFingerprintWarn : ZPassIcons.icFingerprint);
  }
}
