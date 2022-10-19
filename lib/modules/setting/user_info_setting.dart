import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/widgets/list.dart';

class UserInfoSettingPage extends StatefulWidget {
  const UserInfoSettingPage({Key? key}) : super(key: key);

  @override
  State<UserInfoSettingPage> createState() => _UserInfoSettingPageState();
}

class _UserInfoSettingPageState extends State<UserInfoSettingPage> {
  late Color rightColor;
  late TextStyle rightStyle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rightColor = const Color.fromRGBO(149, 155, 167, 1);
    rightStyle = TextStyle(color: rightColor, fontSize: 15);
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
                  child: Material(
                      child: Text(
                    'English',
                    style: rightStyle,
                  ))),
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
                'English',
                style: rightStyle,
              ))),
      RowData(
          text: S.current.fullName,
          right: Material(
              child: Text(
                'English',
                style: rightStyle,
              ))),
      RowData(
          text: S.current.planType,
          right: Material(
              child: Text(
            'Never',
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
            onTap: () {
              NavigatorUtils.goBack(context);
            },
            child: const Icon(
              ZPassIcons.icNavBack,
              color: Color.fromRGBO(94, 99, 103, 1),
              size: 16,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          margin: const EdgeInsets.only(top: 16),
          child: ListWidget(
            rows: rowData,
            withIcon: false,
          ),
        ));
  }
}
