import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/load_image.dart';
import 'package:zpass/modules/user/signin/signin_by_scanner.dart';

class SignInByScannerPage extends StatelessWidget {
  const SignInByScannerPage({Key? key, required this.data}) : super(key: key);
  final String data;

  _handelConfirm(context) async {
    await SignInByScanner()
        .postExtensionsSessionApprove(jsonDecode(data))
        .then((value) => NavigatorUtils.goBack(context))
        .catchError((err) {
      Toast.showMiddleToast(err.toString());
    });
  }

  _handelRefuse(context) async {
    await SignInByScanner()
        .postExtensionsSessionReject(jsonDecode(data))
        .then((value) => NavigatorUtils.goBack(context))
        .catchError((err) {
      Toast.showMiddleToast(err.toString());
      NavigatorUtils.goBack(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            NavigatorUtils.goBack(context);
          },
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              ZPassIcons.icClose,
              color: Color.fromRGBO(94, 99, 103, 1),
              size: 16,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 140.5),
              alignment: Alignment.center,
              child: const LoadAssetImage(
                'signin/login_by_scanner_chrome',
                width: 105.5,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.5),
              child: Text(
                S.current.signInInTo("Chrome"),
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _handelConfirm(context),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(24),
                height: 46,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(23)),
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
                ),
                child: Text(
                  S.current.confirm,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _handelRefuse(context),
              behavior: HitTestBehavior.opaque,
              child: Container(
                alignment: Alignment.center,
                height: 46,
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                child: Text(
                  S.current.refuse,
                  style: const TextStyle(color: Color.fromRGBO(3, 84, 255, 1)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
