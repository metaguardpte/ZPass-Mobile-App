import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/widgets/dialog/zpass_dialog.dart';
import 'package:zpass/util/theme_utils.dart';

/// Usage:
/// final loadingDialog = LoadingDialog();
/// loadingDialog.show(context);
/// loadingDialog.dismiss(context);
class ZPassLoadingDialog extends ZPassDialog {
  late final String _text;

  ZPassLoadingDialog({String text = ""}) {
    _text = text.isEmpty ? S.current.tipsLoading : text;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: context.dialogBackgroundColor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: Text(
                  _text,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: context.textColor1,
                      decoration: TextDecoration.none),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
