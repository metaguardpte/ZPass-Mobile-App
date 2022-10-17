import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/util/callback_funcation.dart';

class RegisterEmailCode extends StatefulWidget {

  FunctionCallback<String>? onResult;
  RegisterEmailCode({this.onResult, Key? key}) : super(key: key);
  @override
  RegisterEmailCodeState createState() => RegisterEmailCodeState();
}

class RegisterEmailCodeState extends State<RegisterEmailCode> {

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(20),
      // margin: const EdgeInsets.only(top: 25, bottom: 5),
      child: _buildTextFields(),
    );
  }

  Widget _buildTextFields() {
    return PinCodeTextField(
      controller: _controller,
      length: 6,
      // autoFocus: true,
      focusNode: _focusNode,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      enableActiveFill: true,
      cursorHeight: 15,
      dialogConfig: DialogConfig(
          dialogTitle: S.current.registerEmailCodeDialogTitle,
          dialogContent: S.current.registerEmailCodeDialogMessage,
          negativeText: S.current.cancel,
          affirmativeText: S.current.paste
      ),
      cursorColor: Colors.black,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          fieldHeight: 43,
          fieldWidth: 43,
          borderWidth: 1,
          activeColor: const Color(0xFFFF4343),
          inactiveColor: const Color(0xFFEBEBEE),
          selectedColor: const Color(0xFFFF4343),
          activeFillColor: Colors.transparent,
          inactiveFillColor: Colors.transparent,
          selectedFillColor: Colors.transparent,
          borderRadius: BorderRadius.circular(7.5)
      ),
      onCompleted: (text) {
        if (widget.onResult != null) {
          widget.onResult!(text);
        }
      },
      appContext: context,
      onChanged: (String value) {},
    );
  }

  void cleanText() {
    setState(() {
      _controller.text = "";
    });
    _focusNode.requestFocus();
  }

  void fillText(String text) {
    setState(() {
      _controller.text = text;
    });
    _focusNode.unfocus();
  }

}