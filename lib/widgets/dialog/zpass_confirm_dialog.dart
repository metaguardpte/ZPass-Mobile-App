import 'package:flutter/material.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/dialog/zpass_dialog.dart';

import '../../generated/l10n.dart';

class ZPassConfirmDialog extends ZPassDialog {
  final String? message;
  final String? confirmText;
  final String? cancelText;
  final bool? reverse;
  final Widget? slotMessage;
  final NullParamCallback? onConfirmTap;
  final NullParamCallback? onCancelTap;

  ZPassConfirmDialog(
      {this.message,
      this.confirmText,
      this.cancelText,
      this.slotMessage,
      this.onConfirmTap,
      this.reverse = false,
      this.onCancelTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFEBEBEE), width: 0.5))
              ),
              child: slotMessage ?? Text(
                message ?? "",
                style: const TextStyle(fontSize: 18, color: Color(0xFF16181A), height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: _buildAction(context, cancelText ?? S.current.actionCancel, isPrimary: reverse ?? false, onTap: onCancelTap)),
                  Gaps.hGap12,
                  Expanded(child: _buildAction(context, confirmText ?? S.current.actionConfirm, isPrimary: !(reverse ?? false), onTap: onConfirmTap)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAction(BuildContext context, String title, {bool isPrimary = false, GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: () {
        dismiss(context);
        if (onTap != null) {
          onTap.call();
        }
      },
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? context.primaryColor : const Color(0x144954FF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: context.primaryColor),
        ),
        child: Text(title, style: TextStyle(fontSize: 16, color: isPrimary ? Colors.white : context.primaryColor)),
      ),
    );
  }

}