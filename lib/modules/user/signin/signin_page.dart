import 'package:flutter/material.dart';
import 'package:zpass/modules/user/signin/signin_form.dart';
import './bg.dart';
import './content_footer.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, this.data}) : super(key: key);
  final String? data;

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          const BackWithLogo(),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 200, 0, 0),
            padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(21))),
            child: Column(
              children: [SignInForm(data: widget.data,), const Spacer(), const ContentFooter()],
            ),
          ),
        ],
      ),
    );
  }
}
