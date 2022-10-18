import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/scanner/router_scanner.dart';
import 'package:zpass/modules/user/signin/psw_input.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/plugin_bridge/crypto/crypto_manager.dart';
import 'package:zpass/res/constant.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/routers/routers.dart';
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

  void handelSignIn() {
    if (kDebugMode) {
      print('SignIn');
    }
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
    CryptoManager.instance.login(Email, Psw,
        Constant.inProduction
            ? "https://ro8d3r7nxb.execute-api.ap-southeast-1.amazonaws.com/Prod"
            : 'https://l8ee0j8yb8.execute-api.ap-southeast-1.amazonaws.com/Prod'
        , SeKey).then((value){
      loadingDialog.dismiss(context);
      UserProvider.instance.updateUser(value);
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
    if (kDebugMode) {
      print('get Email ');
      print(value);
    }
    Email = value;
  }

  getPsw(value) {
    if (kDebugMode) {
      print('get Password ');
      print(value);
    }
    Psw = value;
  }

  getSeKey(value) {
    if (kDebugMode) {
      print('get Secret Key ');
      print(value);
    }
    SeKey = value;
  }

  getQRcode() {
    if (kDebugMode) {
      print('get QrCode ');
    }
    // SeKeyController.text = '1235234';

    NavigatorUtils.pushResult(context, RouterScanner.scanner, (dynamic data){
      // const params = jsonDecode(data);

      final params = jsonDecode(data['data']);
      try{
        if(params != null && params['secretKey'] != null) {
          SeKeyController.text =params['secretKey'];
          SeKey = params['secretKey'];
          emailController.text = params['email'];
          Email = params['email'];
        }
        else{
          Toast.showMiddleToast('don`t get Secret Key');
        }
      }
      catch(e){
        print(e.toString());
        Toast.showMiddleToast('don`t get Secret Key');
      }
    });
  }

  void _initDefaultValue() {
    if ((widget.data ?? "").isEmpty) return;
    final defaultValue = jsonDecode(widget.data!);
    Email = defaultValue["email"] ?? "";
    SeKey = defaultValue["secretKey"] ?? "";
    SeKeyController.text = SeKey;
    emailController.text = Email;
  }

  @override
  void initState() {
    super.initState();
    _initDefaultValue();
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
              margin: const EdgeInsets.fromLTRB(0, 24, 0, 0),
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
          margin: const EdgeInsets.only(top: 57),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 1,
                color:const Color.fromRGBO(149, 155, 167, 0.42),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(S.current.or,style: const TextStyle(color: Color.fromRGBO(149, 155, 167, 1)),),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 25),
          child: GestureDetector(
            onTap: getQRcode,
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
                Text(
                  S.current.siginScan,
                  style: const TextStyle(
                    color: Color.fromRGBO(73, 84, 255, 1),
                  ),
                )
              ],
            ),
          ),
        )

      ],
    );
  }
}
