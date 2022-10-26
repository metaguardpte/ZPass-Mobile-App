import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/content_align_bottom_dialog.dart';
import 'package:zpass/widgets/custom_scroll_behavior.dart';

abstract class ZPassPickerDialog<T> extends ContentAlignBottomDialog {
  String? title;
  final List<T> data;
  final BiFunctionCallback<T, int> onItemSelected;

  ZPassPickerDialog(
      {required this.data,
      required this.onItemSelected,
      String? name,
      this.title})
      : super(name: name);

  @override
  Widget buildContent(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
          color: context.tertiaryBackground,
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

  ///
  /// render picker dialog item widget
  ///
  Widget renderItem(BuildContext context, T item, int index);

  Widget _buildTitle() {
    return Visibility(
      visible: title != null && title?.isNotEmpty == true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 19),
        child: Text(
          title ?? "",
          style: const TextStyle(
            color: Color(0xFF0D2249),
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
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
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            T item = data[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                dismiss(context);
                onItemSelected.call(item, index);
              },
              child: renderItem(context, item, index),
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
          style: TextStyle(color: context.primaryColor, fontSize: 18),
        ),
      ),
    );
  }
}