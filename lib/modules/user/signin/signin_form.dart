import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zpass/base/app_config.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/scanner/router_scanner.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/signin/psw_input.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/plugin_bridge/crypto/crypto_manager.dart';
import 'package:zpass/plugin_bridge/local_auth/local_auth_manager.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/routers/routers.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/dialog/zpass_loading_dialog.dart';
import 'package:zpass/widgets/load_image.dart';
import 'package:zpass/modules/user/signin/zpass_input.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key, this.data}) : super(key: key);
  final String? data;

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  late final loadingDialog = ZPassLoadingDialog();
  FocusNode focusNode = FocusNode();

  String recode(String code) {
    if (code.length < 9) return code;
    var str = code.substring(0, 8);
    return '$str **** **** ****';
  }

  void handelSignIn() {
    if (Email.isEmpty) {
      Toast.showSpec(S.current.signinTip + S.current.email,
          type: ToastType.error);
      return;
    } else if (Psw.isEmpty) {
      Toast.showSpec(S.current.signinTip + S.current.password,
          type: ToastType.error);
      return;
    } else if (SeKey.isEmpty) {
      Toast.showSpec(S.current.signinTip + S.current.seKey,
          type: ToastType.error);
      return;
    }
    loadingDialog.show(context, barrierDismissible: false);
    CryptoManager().login(Email, Psw, AppConfig.serverUrl, SeKey).then((value) {
      UserProvider().userEmail = Email;
      UserProvider().userSecretKey = SeKey;
      UserProvider().userCryptoKey = UserCryptoKeyModel.fromJson(value);
      UserProvider().updateSignInList({"email": Email, "key": SeKey});
      loadingDialog.dismiss(context);
      NavigatorUtils.push(context, Routers.home, clearStack: true);
    }).catchError((error) {
      loadingDialog.dismiss(context);
      Toast.showSpec(S.current.loginFail);
    });
    //submit
  }

  var SeKey = '';
  var Psw = '';
  var Email = '';
  late TextEditingController SeKeyController = TextEditingController();
  late TextEditingController emailController = TextEditingController();

  getEmail(value) {
    Email = value;
    SeKey = '';
    SeKeyController.text = '';
  }

  getPsw(value) {
    Psw = value;
  }

  getSeKey(value) {
    SeKey = value;
  }

  getQRCode() {
    Permission.camera.request().then((status) {
      if (!status.isGranted) {
        Toast.showSpec(
            'No Camera Permission , Please go to the system settings to open the permission',
            type: ToastType.error);
        return;
      }
      NavigatorUtils.pushResult(context, RouterScanner.scanner, (dynamic data) {
        try {
          final params = Uri.parse(data['data']).queryParameters;
          if (params['secretKey'] != null) {
            SeKeyController.text = params['secretKey'] ?? "";
            SeKey = params['secretKey']!;
            emailController.text = params['email'] ?? "";
            Email = params['email'] ?? "";
          } else {
            Toast.showSpec('don`t get Secret Key');
          }
        } catch (e) {
          Log.d(e.toString());
          Toast.showSpec('don`t get Secret Key');
        }
      });
    });
  }

  void _initDefaultValue() {
    final userinfo = UserProvider().userInfo;
    if ((widget.data ?? userinfo.email ?? "").isEmpty) return;
    final defaultValue = jsonDecode(widget.data ?? "{}");
    Email = defaultValue["email"] ?? userinfo.email ?? "";
    SeKey = defaultValue["secretKey"] ?? userinfo.secretKey ?? "";
    SeKeyController.text = recode(SeKey);
    emailController.text = Email;
  }

  void _localAuth() async {
    if (!UserProvider().getUserBiometrics()) return;
    final result = await LocalAuthManager().canAuth();
    if (result) {
      final auth = await LocalAuthManager().authenticate();
      Log.d("local auth result is:$auth");
    }
  }

  @override
  void initState() {
    super.initState();
    _initDefaultValue();
    _localAuth();
    // 添加listener监听
    // 对应的TextField失去或者获取焦点都会回调此监听
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // print('得到焦点');
      } else {
        var key = UserProvider().getUserKeyByEmail(Email);
        if (key != null) {
          SeKeyController.text = recode(key);
          SeKey = key;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(246, 246, 246, 1),
                borderRadius: BorderRadius.all(Radius.circular(7.5))),
            child: ZPassTextFieldWidget(
              icon: const LoadAssetImage(
                'signin/email@2x',
                width: 20,
                height: 20,
              ),
              onChanged: getEmail,
              hintText: S.current.email,
              controller: emailController,
              focusNode: focusNode,
            )),
        Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(246, 246, 246, 1),
                borderRadius: BorderRadius.all(Radius.circular(7.5))),
            child: PswInput(
              onChange: getPsw,
            )),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(246, 246, 246, 1),
              borderRadius: BorderRadius.all(Radius.circular(7.5))),
          child: Container(
            child: ZPassTextFieldWidget(
              icon: const LoadAssetImage(
                'signin/safe@2x',
                width: 20,
                height: 20,
              ),
              controller: SeKeyController,
              hintText: S.current.seKey,
              onChanged: getSeKey,
            ),
          ),
        ),
        GestureDetector(
            onTap: handelSignIn,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              width: double.infinity,
              alignment: Alignment.center,
              height: 46,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(246, 246, 246, 1),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [
                        0,
                        1
                      ],
                      colors: [
                        Color.fromRGBO(82, 115, 254, 1),
                        Color.fromRGBO(67, 66, 255, 1)
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(23))),
              child: Text(
                S.current.login,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            )),
        Container(
          margin: const EdgeInsets.only(top: 80),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 1,
                color: const Color.fromRGBO(149, 155, 167, 0.42),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  S.current.or,
                  style:
                      const TextStyle(color: Color.fromRGBO(149, 155, 167, 1)),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: getQRCode,
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
        ),
      ],
    );
  }
}
