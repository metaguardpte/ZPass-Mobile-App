import 'package:flutter/material.dart';
import 'package:zpass/widgets/dialog/zpass_picker_dialog.dart';

class ZPassSelectionDialog extends ZPassPickerDialog {
  ZPassSelectionDialog(
      {required super.data, required super.onItemSelected, super.title})
      : super(name: "ZPassSelectionDialog");

  @override
  Widget renderItem(BuildContext context, item, int index) {
    return Container(
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
        item,
        style: const TextStyle(color: Color(0xFF16181A), fontSize: 18),
      ),
    );
  }


}