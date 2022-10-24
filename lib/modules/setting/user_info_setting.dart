import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/user/model/user_info_model.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/routers/routers.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/dialog/zpass_confirm_dialog.dart';
import 'package:zpass/widgets/list.dart';
import 'package:zpass/widgets/load_image.dart';

class UserInfoSettingPage extends StatefulWidget {
  const UserInfoSettingPage({Key? key}) : super(key: key);

  @override
  State<UserInfoSettingPage> createState() => _UserInfoSettingPageState();
}

class _UserInfoSettingPageState extends State<UserInfoSettingPage> {
  late Color rightColor;
  late TextStyle rightStyle;
  UserInfoModel userInfo = UserProvider().userInfo;

  @override
  void initState() {
    super.initState();
    rightColor = const Color.fromRGBO(149, 155, 167, 1);
    rightStyle = TextStyle(color: rightColor, fontSize: 15);
  }

  _onSignOutTap() {
    ZPassConfirmDialog(
        message: S.current.logoutTitle,
        confirmText: S.current.signOut,
        onConfirmTap: _doSignOut,
    ).show(context);
  }

  _doSignOut() {
    UserProvider().clear();
    Toast.showMiddleToast(S.current.logoutSuccess,
        type: ToastType.info);
    NavigatorUtils.push(context, Routers.loginOrNew, clearStack: true);
  }

  @override
  Widget build(BuildContext context) {
    List<RowData> rowData = [
      RowData(
          text: S.current.photo,
          right: Row(
            children: [
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: LoadImage(
                      userInfo.icon ?? '',
                      width: 34,
                      height: 34,
                    ),
                  )),
              Icon(
                ZPassIcons.icArrowRight,
                color: rightColor,
                size: 10,
              )
            ],
          )),
      RowData(
          text: S.current.email,
          right: Material(
              child: Text(
            userInfo.email ?? 'Email',
            style: rightStyle,
          ))),
      RowData(
          text: S.current.fullName,
          right: Material(
              child: Text(
            userInfo.name ?? 'UserName',
            style: rightStyle,
          ))),
      RowData(
          text: S.current.planType,
          right: Material(
              child: Text(
            userInfo.type ?? 'PlanType',
            style: rightStyle,
          ))),
    ];
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            S.current.profile,
            style: const TextStyle(color: Colors.black),
          ),
          leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              NavigatorUtils.goBack(context);
            },
            child: Container(
              width: 40,
              height: 40,
              child: const Icon(
                ZPassIcons.icNavBack,
                color: Color.fromRGBO(94, 99, 103, 1),
                size: 16,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              margin: const EdgeInsets.only(top: 16),
              child: ListWidget(
                rows: rowData,
                withIcon: false,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _onSignOutTap,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(23))),
                margin: const EdgeInsets.fromLTRB(16, 9, 16, 48),
                child: Text(
                  S.current.logout,
                  style: const TextStyle(
                      color: Color.fromRGBO(73, 84, 255, 1), fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}
