import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/setting/switch.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/plugin_bridge/local_auth/local_auth_manager.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/device_utils.dart';
import 'package:zpass/widgets/dialog/zpass_confirm_dialog.dart';
import 'package:zpass/widgets/list.dart';

class SecurityWidget extends StatefulWidget {
  const SecurityWidget({Key? key,required this.rightStyle,required this.rightColor}) : super(key: key);
  final TextStyle rightStyle;
  final Color rightColor;

  @override
  State<SecurityWidget> createState() => _SecurityWidgetState();
}

class _SecurityWidgetState extends State<SecurityWidget> {

 final List<RowData> _rowDataList = [];

 @override
  void initState() {
    super.initState();
    _initDefaultRowData();
    _initBiometricsRowData();
  }

 @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.only(top: 16),
          child: Material(
            color: Colors.transparent,
            child: Text(
              S.current.General,
              style: const TextStyle(
                  color: Color.fromRGBO(149, 155, 167, 1), fontSize: 14),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: ListWidget(
            rows: _rowDataList,
          ),
        )
      ],
    );
  }

  void _initDefaultRowData() {
   final autoLock = RowData(
     text: S.current.AutoLock,
     icon: const Icon(ZPassIcons.icLock, size: 18),
     right: Row(
       children: [
         const Spacer(),
         Padding(
           padding: const EdgeInsets.only(right: 10),
           child: Material(child: Text('English', style: widget.rightStyle)),
         ),
         Icon(ZPassIcons.icArrowRight, color: widget.rightColor, size: 10),
       ],
     ),
   );
   final secretKey = RowData(
       text: S.current.seKey,
       icon: const Icon(ZPassIcons.icSecretKey, size: 18),
       right: Row(
         children: [
           const Spacer(),
           Padding(
             padding: const EdgeInsets.only(right: 10),
             child: Material(child: Text('OFF', style: widget.rightStyle)),
           ),
           Icon(ZPassIcons.icArrowRight, color: widget.rightColor, size: 10),
         ],
       ),
   );
   _rowDataList.add(autoLock);
   _rowDataList.add(secretKey);
  }

 void _initBiometricsRowData() async {
   final bool canAuth = await LocalAuthManager().canAuth();
   if (!canAuth) return;

   if (Device.isAndroid) {
     final biometrics = RowData(
       text: S.current.UnlockWithBiometrics,
       icon: const Icon(ZPassIcons.icBiometrics, size: 18),
       right: ListSwitch(onChange: _doSwitchBiometrics),
     );
     _rowDataList.add(biometrics);
   } else {
     final bool isSupportedFingerprint = await LocalAuthManager().isSupportedFingerprint();
     if (isSupportedFingerprint) {
       final fingerprint = RowData(
         text: S.current.UnlockWithFinger,
         icon:const Icon( ZPassIcons.icFingerprint, size: 18),
         right: ListSwitch(onChange: _doSwitchBiometrics),
       );
       _rowDataList.add(fingerprint);
     }
     final bool isSupportedFaceID = await LocalAuthManager().isSupportedFaceID();
     if (isSupportedFaceID) {
       final faceID = RowData(
         text: S.current.UnlockWithFace,
         icon:const Icon( ZPassIcons.icFaceID, size: 18),
         right: ListSwitch(onChange: _doSwitchBiometrics),
       );
       _rowDataList.add(faceID);
     }
   }
   setState(() {});
 }

  Future<bool?> _doSwitchBiometrics(bool isOpen) {
    Completer<bool?> locker = Completer();
    if (isOpen) {
      ZPassConfirmDialog(
        message: S.current.settingConfirmMasterPassword,
        isInput: true,
        onInputChange: (value) {
          print(value);
        },
        onConfirmTap: () {
          UserProvider().putUserBiometrics(true);
          locker.complete(true);
        },
        onCancelTap: () => locker.complete(null),
      ).show(context, barrierDismissible: false);
    } else {
      UserProvider().putUserBiometrics(false);
      locker.complete(false);
    }
    return locker.future;
  }
}
