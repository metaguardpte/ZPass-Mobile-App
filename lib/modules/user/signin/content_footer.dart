import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/user/register/router_register.dart';
import 'package:zpass/routers/fluro_navigator.dart';
class ContentFooter extends StatelessWidget {
  const ContentFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text(
          S.current.zpassLink,
          style:const TextStyle(
              color: Color.fromRGBO(149, 155, 167, 1), fontSize: 15),
        ),
      ],
    );
  }

  _navigatorToRegisterPage(BuildContext context) {
    NavigatorUtils.push(context, RouterRegister.register);
  }
}
