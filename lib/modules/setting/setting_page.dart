import 'package:flutter/material.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/modules/setting/general.dart';
import 'package:zpass/modules/setting/provider/setting_provider.dart';
import 'package:zpass/modules/setting/router_settting.dart';
import 'package:zpass/modules/setting/security.dart';
import 'package:zpass/modules/user/model/user_info_model.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/widgets/load_image.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ProviderState<SettingPage, SettingProvider> {
  bool _fingerPrintType = false;

  onFingerPrintChange(bool value) {
    _fingerPrintType = value;
  }

  late Color _rightColor;
  late TextStyle _rightTextStyle;

  @override
  void initState() {
    super.initState();
    _rightColor = const Color.fromRGBO(149, 155, 167, 1);
    _rightTextStyle = TextStyle(color: _rightColor, fontSize: 15);
  }

  @override
  Widget buildContent(BuildContext context) {
    UserInfoModel userInfo = UserProvider().profile.data;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: const EdgeInsets.fromLTRB(16, 20.5, 16, 20.5),
          color: const Color.fromRGBO(247, 247, 247, 1),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      NavigatorUtils.goBack(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(top: 18),
                      // alignment: Alignment.centerLeft,
                      child: Icon(
                        ZPassIcons.icClose,
                        color: _rightColor,
                        size: 18.5,
                      ),
                    )),
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(11.5, 19.5, 13, 19.5),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(11))),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(50)),
                        child: LoadImage(
                          userInfo.avatar ?? '',
                          width: 34,
                          height: 34,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Material(
                                  child: Text(
                                    userInfo.userName ?? 'ZPASS',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Material(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    padding:
                                    const EdgeInsets.fromLTRB(7, 3, 7, 3),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        color: const Color.fromRGBO(
                                            73, 84, 255, 0.0800),
                                        border: Border.all(
                                            width: 1,
                                            color: const Color.fromRGBO(
                                                73, 84, 255, 0.3000))),
                                    child: Text(
                                      userInfo.type,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color:
                                          Color.fromRGBO(73, 84, 255, 1)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Material(
                              child: Text(
                                userInfo.email ?? '',
                                style: const TextStyle(
                                    color: Color.fromRGBO(149, 155, 167, 1)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        ZPassIcons.icArrowRight,
                        color: _rightColor,
                        size: 10,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  NavigatorUtils.push(context, RouterSetting.userInfoSetting);
                },
              ),
              GeneralWidget(
                  rightStyle: _rightTextStyle, rightColor: _rightColor),
              SecurityWidget(
              provider: provider,
              rightStyle: _rightTextStyle,
              rightColor: _rightColor,
            )
          ],
          ),
      ),
    );
  }

  @override
  SettingProvider prepareProvider() {
    return SettingProvider();
  }
}
