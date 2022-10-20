import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:zpass/base/app_config.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/scanner/router_scanner.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/signin/psw_input.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/plugin_bridge/crypto/crypto_manager.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/routers/routers.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/dialog/zpass_loading_dialog.dart';
import 'package:zpass/widgets/load_image.dart';

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
    var str = code.substring(0, 8);
    return '$str **** **** ****';
  }

  void handelSignIn() {
    if (Email.isEmpty) {
      Toast.showMiddleToast(S.current.signinTip + S.current.email,
          type: ToastType.error);
      return;
    } else if (Psw.isEmpty) {
      Toast.showMiddleToast(S.current.signinTip + S.current.password,
          type: ToastType.error);
      return;
    } else if (SeKey.isEmpty) {
      Toast.showMiddleToast(S.current.signinTip + S.current.seKey,
          type: ToastType.error);
      return;
    }
    loadingDialog.show(context, barrierDismissible: false);
    CryptoManager().login(Email, Psw, AppConfig.serverUrl, SeKey).then((value) {
      UserProvider().updateEmail(Email);
      UserProvider().updateSecretKey(SeKey);
      UserProvider().updateUserCryptoKey(UserCryptoKeyModel.fromJson(value));
      UserProvider().updateSignInList({"email": Email, "key": SeKey});
      loadingDialog.dismiss(context);
      NavigatorUtils.push(context, Routers.home);
    }).catchError((error) {
      loadingDialog.dismiss(context);
      Toast.showMiddleToast("Login Failed: ${error.toString()}");
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
  }

  getPsw(value) {
    Psw = value;
  }

  getSeKey(value) {
    SeKey = value;
  }

  getQRcode() async {
    var status = await Permission.camera.request();
    if (!status.isGranted) {
      Toast.showMiddleToast(
          'No Camera Permission , Please go to the system settings to open the permission',
          height: 180,
          type: ToastType.error);
      return;
    }
    NavigatorUtils.pushResult(context, RouterScanner.scanner, (dynamic data) {
      final params = jsonDecode(data['data']);
      try {
        if (params != null && params['secretKey'] != null) {
          SeKeyController.text = recode(params['secretKey']);
          SeKey = params['secretKey'];
          emailController.text = params['email'];
          Email = params['email'];
        } else {
          Toast.showMiddleToast('don`t get Secret Key');
        }
      } catch (e) {
        Log.d(e.toString());
        Toast.showMiddleToast('don`t get Secret Key');
      }
    });
  }

  void _initDefaultValue() {
    final userinfo = UserProvider().getUserInfo();

    if ((widget.data ?? userinfo.email ?? "").isEmpty) return;
    final defaultValue = jsonDecode(widget.data ?? "{}");
    Email = defaultValue["email"] ?? userinfo.email ?? "";
    SeKey = defaultValue["secretKey"] ?? userinfo.secretKey ?? "";
    SeKeyController.text = recode(SeKey);
    emailController.text = Email;
  }

  @override
  void initState() {
    super.initState();
    _initDefaultValue();
    //添加listener监听
    //对应的TextField失去或者获取焦点都会回调此监听
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        print('得到焦点');
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
          child: TextField(
            onChanged: getEmail,
            focusNode: focusNode,
            controller: emailController,
            decoration: InputDecoration(
                icon: const LoadAssetImage(
                  'signin/email@2x',
                  width: 20,
                  height: 20,
                ),
                hintText: S.current.email,
                hintStyle:
                    const TextStyle(color: Color.fromRGBO(147, 151, 157, 1)),
                border: InputBorder.none),
          ),
        ),
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
          child: TextField(
            controller: SeKeyController,
            onChanged: getSeKey,
            decoration: InputDecoration(
                icon: const LoadAssetImage(
                  'signin/safe@2x',
                  width: 20,
                  height: 20,
                ),
                hintText: S.current.seKey,
                hintStyle:
                    const TextStyle(color: Color.fromRGBO(147, 151, 157, 1)),
                border: InputBorder.none),
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
          onTap: getQRcode,
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
