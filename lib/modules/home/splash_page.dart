import 'package:flutter/material.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/routers/routers.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/widgets/load_image.dart';

class SplashPage extends StatefulWidget {
  // final FunctionCallback<BuildContext> authCallback;

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool? _isUserAuthorized;

  @override
  void initState() {
    // FlutterLinkfox.isUserAuthorized.then((isUserAuthorized) {
    //   Log.d("isUserAuthorized => $isUserAuthorized");
    //   if(isUserAuthorized == false) {
    //     _isUserAuthorized = false;
    //     Future.delayed(const Duration(milliseconds: 350), () => setState(() {}));
    //   } else {
    //     Future.delayed(const Duration(milliseconds: 1000), () => widget.authCallback(context));
    //   }
    // });
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => NavigatorUtils.push(context, Routers.home, clearStack: true));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: const LoadAssetImage("home/slogan", width: 160, height: 61, fit: BoxFit.contain,)
            ),
            const Center(child: Text("Hello ZPass")),
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