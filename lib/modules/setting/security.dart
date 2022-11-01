import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/setting/provider/setting_provider.dart';
import 'package:zpass/modules/setting/switch.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/plugin_bridge/crypto/crypto_manager.dart';
import 'package:zpass/plugin_bridge/local_auth/local_auth_manager.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/device_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/dialog/zpass_confirm_dialog.dart';
import 'package:zpass/widgets/dialog/zpass_selection_dialog.dart';
import 'package:zpass/widgets/list.dart';

class SecurityWidget extends StatefulWidget {
  const SecurityWidget({
    Key? key,
    required this.provider,
    required this.rightStyle,
    required this.rightColor,
  }) : super(key: key);
  final TextStyle rightStyle;
  final Color rightColor;
  final SettingProvider provider;

  @override
  State<SecurityWidget> createState() => _SecurityWidgetState();
}

class _SecurityWidgetState extends ProviderState<SecurityWidget, SettingProvider> {

 List<RowData> _rowDataList = [];
 String _confirmPassword = "";
 final _requirePasswordDays = [7, 14, 30];

  @override
  void initState() {
    super.initState();
    provider.userRequirePassword = S.current.settingRequirePasswordDays(
        UserProvider().biometrics.getRequirePasswordDay());
    _initDefaultRowData();
    _initBiometricsRowData();
  }

 @override
  Widget buildContent(BuildContext context) {
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

   final bool isOpen = UserProvider().biometrics.getUserBiometrics();
   if (Device.isAndroid) {
     final biometrics = RowData(
       text: S.current.UnlockWithBiometrics,
       icon: const Icon(ZPassIcons.icBiometrics, size: 18),
       right: ListSwitch(onChange: _doSwitchBiometrics, defaultValue: isOpen,),
     );
     _rowDataList.add(biometrics);
   } else {
     final bool isSupportedFingerprint = await LocalAuthManager().isSupportedFingerprint();
     if (isSupportedFingerprint) {
       final fingerprint = RowData(
         text: S.current.UnlockWithFinger,
         icon: const Icon(ZPassIcons.icFingerprint, size: 18),
         right: ListSwitch(onChange: _doSwitchBiometrics, defaultValue: isOpen,),
       );
       _rowDataList.add(fingerprint);
     }
     final bool isSupportedFaceID = await LocalAuthManager().isSupportedFaceID();
     if (isSupportedFaceID) {
       final faceID = RowData(
         text: S.current.UnlockWithFace,
         icon: const Icon(ZPassIcons.icFaceID, size: 18),
         right: ListSwitch(onChange: _doSwitchBiometrics, defaultValue: isOpen,),
       );
       _rowDataList.add(faceID);
     }
   }

   final requirePassword = RowData(
        text: S.current.settingRequirePassword,
        icon: const Icon(ZPassIcons.icRequirePassword, size: 18),
     right: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _doSelectedRequirePassword,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Material(
                  child: Selector<SettingProvider, String>(
                    builder: (_, day, __) {
                      return Text(
                        day,
                        style: widget.rightStyle,
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                    selector: (_, provider) => provider.userRequirePassword,
                  ),
                ),
              ),
            ),
            Icon(ZPassIcons.icArrowRight, color: widget.rightColor, size: 10),
          ],
        ),
      ),
    );
   _rowDataList.add(requirePassword);
    setState(() {});
 }

  Future<bool?> _doSwitchBiometrics(bool isOpen) async {
   if (!isOpen) {
     UserProvider().biometrics.putUserBiometrics(false);
     return Future.value(false);
   }
   final bool auth = await LocalAuthManager().authenticate();
   if (!auth) return Future.value(null);

   return _showConfirmPasswordDialog();
  }

  Future<bool?> _showConfirmPasswordDialog() {
   _confirmPassword = "";
    Completer<bool?> locker = Completer();
    ZPassConfirmDialog(
      message: S.current.settingConfirmMasterPassword,
      isInput: true,
      onInputChange: (value) => _confirmPassword = value,
      onConfirmTap: () async {
        final result = await _doVerifyPassword();
        locker.complete(result);
      },
      onCancelTap: () => locker.complete(null),
    ).show(context, barrierDismissible: false);
    return locker.future;
  }

  Future<bool?> _doVerifyPassword() async {
    if (_confirmPassword.isEmpty) {
      Toast.showSpec("Master password is empty");
      return await _showConfirmPasswordDialog();
    }
    final userInfo = UserProvider().profile.data;
    final hash = CryptoManager().calcPasswordHash(
        user: userInfo.email ?? "",
        password: _confirmPassword,
        secretKey: userInfo.secretKey ?? "",
    );
    if (hash != userInfo.userCryptoKey?.masterKeyHash) {
      Toast.showSpec("Master password is error");
      return await _showConfirmPasswordDialog();
    }
    UserProvider().biometrics.putUserBiometrics(true);
    return true;
  }

  _doSelectedRequirePassword() {
    final selections = _requirePasswordDays.map((e) => S.current.settingRequirePasswordDays(e));
    ZPassSelectionDialog(
      data: selections.toList(),
      title: S.current.settingRequirePassword,
      onItemSelected: (item, index) {
        UserProvider().biometrics.putRequirePasswordDay(_requirePasswordDays[index]);
        provider.userRequirePassword = item;
      },
    ).show(context);
  }

  @override
  SettingProvider prepareProvider() {
    return widget.provider;
  }
}
