import 'package:flutter/material.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/widgets/load_image.dart';
import 'package:zpass/generated/l10n.dart';

class SplashPage extends StatefulWidget {
  final FunctionCallback<BuildContext> authCallback;

  const SplashPage({Key? key, required this.authCallback}) : super(key: key);

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
    Future.delayed(const Duration(seconds: 2), () {
      // fake auth
      widget.authCallback.call(context);
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