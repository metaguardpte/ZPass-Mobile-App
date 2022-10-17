import 'package:flutter/material.dart';
import 'package:zpass/modules/user/register/router_register.dart';
import 'package:zpass/routers/fluro_navigator.dart';
class ContentFooter extends StatelessWidget {
  const ContentFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Don`t have an account?',
          style: TextStyle(
              color: Color.fromRGBO(22, 24, 26, 1), fontSize: 14),
        ),
        GestureDetector(
          onTap: () => _navigatorToRegisterPage(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 56),
              child: const Text(
                'Create Account',
                style: TextStyle(
                    color: Color.fromRGBO(73, 84, 255, 1), fontSize: 14),
              )),
        ),
        const Text(
          'zpassap.com',
          style: TextStyle(
              color: Color.fromRGBO(149, 155, 167, 1), fontSize: 15),
        ),
      ],
    );
  }

  _navigatorToRegisterPage(BuildContext context) {
    NavigatorUtils.push(context, RouterRegister.register);
  }
}
