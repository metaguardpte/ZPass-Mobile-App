import 'package:flutter/material.dart';
import 'package:zpass/widgets/content_align_bottom_dialog.dart';

class LocaleDialog extends ContentAlignBottomDialog {
  @override
  Widget buildContent(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(double.infinity, MediaQuery.of(context).size.height/3)),
      child: const Center(child: Text("What do you want ?"),),
    );
  }
}