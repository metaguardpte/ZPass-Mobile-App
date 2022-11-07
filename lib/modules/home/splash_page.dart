import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zpass/main_initializer.dart';
import 'package:zpass/modules/user/router_user.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/routers/routers.dart';
import 'package:zpass/widgets/load_image.dart';
import 'package:zpass/generated/l10n.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      // fake auth
      MainInitializer.initAfterAuthorize().then((credentialExist) {
        if (credentialExist) {
          NavigatorUtils.push(context, RouterUser.login,  clearStack: true, arguments: {"data": jsonEncode({ "canAuth": true })});
        } else {
          NavigatorUtils.push(context, Routers.loginOrNew, clearStack: true);
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children:  [
            const LoadAssetImage("entrance/entrance_bg", width: double.infinity, height: double.infinity),
            Container(
              margin: const EdgeInsets.only(top: 230),
              child: const Align(
                alignment: Alignment.topCenter,
                child: LoadAssetImage('entrance/logo',
                  width: 265,),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 24.5),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(S.current.zpassLink,
                    style: const TextStyle(
                      color: Color.fromRGBO(149, 155, 167, 0.66)
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onAgreementChoice(bool isUserAuthorized) {
    if(isUserAuthorized) {
    } else {
    }
  }
}