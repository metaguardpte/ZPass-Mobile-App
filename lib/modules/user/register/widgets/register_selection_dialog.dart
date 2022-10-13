import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/widgets/content_align_bottom_dialog.dart';
import 'package:zpass/widgets/custom_scroll_behavior.dart';

class RegisterSelectionDialog extends ContentAlignBottomDialog {
  RegisterSelectionDialog({this.title, this.data, this.onSelectedTap});
  final String? title;
  final List<String>? data;
  final FunctionCallback<int>? onSelectedTap;
  @override
  Widget buildContent(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            _buildTitle(),
            _buildList(),
            _buildCancel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 19),
      child: Text(
        title ?? "",
        style: const TextStyle(
            color: Color(0xFF0D2249),
            fontSize: 19,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  Widget _buildList() {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            String value = "";
            if (data != null) {
              value = data![index];
            }
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                dismiss(context);
                if (onSelectedTap != null) {
                  onSelectedTap?.call(index);
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(235, 235, 235, 0.7),
                      width: 0.5,
                    ),
                  ),
                ),
                height: 53,
                child: Text(
                  value,
                  style: const TextStyle(color: Color(0xFF16181A), fontSize: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCancel(BuildContext context) {
    return GestureDetector(
      onTap: () => dismiss(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        height: 53,
        child: Text(
          S.current.cancel,
          style: const TextStyle(color: Color(0xFF4954FF), fontSize: 18),
        ),
      ),
    );
  }
}