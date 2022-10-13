import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../widgets/load_image.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  void handelSignIn() {
    if (kDebugMode) {
      print('123213');
    }
  }

  getQRcode() {
    if (kDebugMode) {
      print('get QrCode ');
    }
  }
  switchPassword(){
    if (kDebugMode) {
      print('switch Password');
    }
  }

  var _showPasword = false;

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
            obscureText: _showPasword,
            decoration: const InputDecoration(
                icon: LoadAssetImage(
                  'signin/email@2x',
                  width: 20,
                  height: 20,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Color.fromRGBO(147, 151, 157, 1)),
                border: InputBorder.none),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(246, 246, 246, 1),
              borderRadius: BorderRadius.all(Radius.circular(7.5))),
          child: TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                suffixIcon: IconButton(
                    onPressed: switchPassword,
                    icon: const LoadAssetImage(
                      'signin/pass-off@2x',
                      width: 20,
                      height: 20,
                    )),
                icon: const LoadAssetImage(
                  'signin/LockKey@2x',
                  width: 20,
                  height: 20,
                ),
                hintText: 'Password',
                hintStyle: const TextStyle(color: Color.fromRGBO(147, 151, 157, 1)),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                )),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(246, 246, 246, 1),
              borderRadius: BorderRadius.all(Radius.circular(7.5))),
          child: TextField(
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                suffixIcon: IconButton(
                    onPressed: getQRcode,
                    icon: const LoadAssetImage(
                      'signin/qrcode@2x',
                      width: 20,
                      height: 20,
                    )),
                icon: const LoadAssetImage(
                  'signin/safe@2x',
                  width: 20,
                  height: 20,
                ),
                hintText: 'Secret Key',
                hintStyle: TextStyle(color: Color.fromRGBO(147, 151, 157, 1)),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                )),
          ),
        ),
        Container(
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
            child: GestureDetector(
              onTap: handelSignIn,
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            )),
      ],
    );
  }
}
