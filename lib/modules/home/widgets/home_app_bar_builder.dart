import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpass/base/api/login_service.dart';
import 'package:zpass/modules/home/home_page_v2.dart';
import 'package:zpass/modules/home/widgets/home_widget_builder.dart';
import 'package:zpass/modules/scanner/router_scanner.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/load_image.dart';

class HomeAppBarBuilder extends HomeWidgetBuilder {
  final _loginRequest = LoginServices();
  final FunctionCallback<HomePageAction> onActionCallback;

  HomeAppBarBuilder(this.onActionCallback);

  @override
  PreferredSizeWidget build(BuildContext context) {
    Future<void> _loginByQrCode(dynamic data) async {
      await _loginRequest
          .postExtensionsSessionScanned(data['identity'])
          .then((value) async {
        log('-------- mobile login success ------');
        await _loginRequest.postExtensionsSessionApprove(data['identity']);
      }).catchError((err) async {
        log('-------- mobile login fail --------');
        log(err.toString());
        await _loginRequest.postExtensionsSessionReject(data['identity']);
      });
    }

    void _scan() {
      NavigatorUtils.pushResult(context, RouterScanner.scanner, (dynamic data) {
        try {
          final params = data['data'];
          _loginByQrCode(jsonDecode(params))
              .then((value) => Toast.showMiddleToast('Mobile Login Success'))
              .catchError((err) {
            Toast.showMiddleToast(err.toString());
          });
        } catch (e) {
          Log.d(e.toString());
        }
      });
    }

    final Color? iconColor = ThemeUtils.getIconColor(context);
    return AppBar(
        automaticallyImplyLeading: applyLeading(),
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          child: const LoadAssetImage("logo_zpass"),
        ),
        leadingWidth: 110,
        backgroundColor: context.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: <Color>[Color(0xFF5273FE), Color(0xFF4342FF)]),
          ),
        ),
        actions: [
          IconButton(
            tooltip: HomePageAction.scan.name,
            onPressed: _scan,
            icon: Icon(
              ZPassIcons.icScan,
              color: iconColor,
            ),
          ),
          IconButton(
            tooltip: HomePageAction.message.name,
            onPressed: () => _navigate(context, HomePageAction.message),
            icon: Icon(
              ZPassIcons.icInformation,
              color: iconColor,
            ),
          ),
          IconButton(
            tooltip: HomePageAction.setting.name,
            onPressed: () => _navigate(context, HomePageAction.setting),
            icon: Icon(
              ZPassIcons.icMore,
              color: iconColor,
            ),
          ),
        ]);
  }

  @override
  bool applyLeading() {
    return false;
  }

  void _navigate(BuildContext context, HomePageAction action) {
    Log.d("navigate to ${action.name}", tag: "HomeAppBarBuilder");
    onActionCallback.call(action);
  }
}
