import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/dialog/zpass_dialog.dart';
import 'package:zpass/widgets/zpass_form_edittext.dart';

class ZPassConfirmDialog extends ZPassDialog {
  final String? message;
  final String? confirmText;
  final String? cancelText;
  final bool? reverse;
  final Widget? slotMessage;
  final bool? isInput;
  final bool? inputObscureText;
  final NullParamCallback? onConfirmTap;
  final NullParamCallback? onCancelTap;
  final FunctionCallback<String>? onInputChange;

  ZPassConfirmDialog(
      {this.message,
      this.confirmText,
      this.cancelText,
      this.slotMessage,
      this.onConfirmTap,
      this.reverse = false,
      this.isInput = false,
      this.inputObscureText = false,
      this.onInputChange,
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
            _buildMessage(),
            _buildInputContainer(context),
            Gaps.vGap15,
            _buildFooter(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 12),
      child: slotMessage ?? Text(
        message ?? "",
        style: const TextStyle(fontSize: 18, color: Color(0xFF16181A), height: 1.5),
        textAlign: TextAlign.center,
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
  
  Widget _buildInputContainer(BuildContext context) {
    final textField = Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ZPassFormEditText(
        prefix: Gaps.empty,
        obscureText: inputObscureText!,
        autofocus: true,
        bgColor: Colors.white,
        focusBgColor: Colors.white,
        borderColor: const Color(0xFFEBEBEE),
        onChanged: onInputChange,
      ),
    );
    return isInput == true ? textField : Gaps.empty;
  }
  
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFEBEBEE), width: 0.5))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: _buildAction(context, cancelText ?? S.current.actionCancel, isPrimary: reverse ?? false, onTap: onCancelTap)),
          Gaps.hGap12,
          Expanded(child: _buildAction(context, confirmText ?? S.current.actionConfirm, isPrimary: !(reverse ?? false), onTap: onConfirmTap)),
        ],
      ),
    );
  }
}