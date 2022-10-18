import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/user/register/router_register.dart';
import 'package:zpass/modules/user/router_user.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/widgets/load_image.dart';

class LoginOrNewPage extends StatelessWidget {
  const LoginOrNewPage({Key? key}) : super(key: key);

  toLoginPage(context) {
    NavigatorUtils.push(context,RouterUser.login);
  }

  toCreateAccountPage(context) {
    NavigatorUtils.push(context, RouterRegister.register,);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: LoadAssetImage("entrance/entrance_bg2", width:MediaQuery.of(context).size.width,fit: BoxFit.fill,),
          ),
          Container(
            margin: const EdgeInsets.only(top: 187),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  const LoadAssetImage(
                    'entrance/logo_white',
                    width: 174,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(31, 24, 31, 0),
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        S.current.signinOrNewTip,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 19, height: 1.4),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: (){
                    toCreateAccountPage(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 327,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
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
                    // color: ,
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Text(
                          S.current.createAccount,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:(){
                    toLoginPage(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 327,
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.08),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(73, 84, 255, 1)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(23))),
                    // color: ,
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Text(
                          S.current.login,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(73, 84, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Material(
                    child: Text(
                      S.current.zpassLink,
                      style: const TextStyle(
                          color: Color.fromRGBO(149, 155, 167, 0.66)),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
