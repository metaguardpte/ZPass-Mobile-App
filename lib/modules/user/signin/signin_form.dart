import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:zpass/modules/user/signin/psw_input.dart';
import 'package:zpass/modules/user/signin/secretKey_input.dart';
import 'package:zpass/util/toast_utils.dart';
import '../../../widgets/load_image.dart';
import 'package:zpass/generated/l10n.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  void handelSignIn() {
    if (kDebugMode) {
      print('SignIn');
    }
    if(Email.isEmpty){
      Toast.showMiddleToast(S.current.signinTip + S.current.email,type: ToastType.error);
      return ;
    }
    else if(Psw.isEmpty){
      Toast.showMiddleToast(S.current.signinTip + S.current.password,type: ToastType.error);
      return ;
    }
    else if(SeKey.isEmpty){
      Toast.showMiddleToast(S.current.signinTip + S.current.seKey,type: ToastType.error);
      return ;
    }

    //submit
  }
  var SeKey = '';
  var Psw = '';
  var Email = '';

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
            decoration: InputDecoration(
                icon:const LoadAssetImage(
                  'signin/email@2x',
                  width: 20,
                  height: 20,
                ),
                hintText: S.current.email,
                hintStyle:const TextStyle(color: Color.fromRGBO(147, 151, 157, 1)),
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
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(246, 246, 246, 1),
              borderRadius: BorderRadius.all(Radius.circular(7.5))),
          child: SecretKey(
            onChange: getSeKey,
          ),
        ),
        GestureDetector(
            onTap: handelSignIn,
            child:Container(
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
                style:const TextStyle(fontSize: 16, color: Colors.white),
              ),
            )),
      ],
    );
  }
}
