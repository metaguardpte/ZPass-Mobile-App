import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/util/callback_funcation.dart';

class RegisterProtocolCheckbox extends StatefulWidget {
  const RegisterProtocolCheckbox({Key? key, this.onChange}) : super(key: key);

  final FunctionCallback<bool>? onChange;

  @override
  State<RegisterProtocolCheckbox> createState() => _RegisterProtocolCheckboxState();
}

class _RegisterProtocolCheckboxState extends State<RegisterProtocolCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCheckbox(),
          Flexible(child: _buildProtocolText()),
        ],
      ),
    );
  }
  
  Widget _buildCheckbox() {
    return Checkbox(
        value: _isChecked,
        onChanged: (bool? value) {
          setState(() {
            _isChecked = value!;
          });
          if (widget.onChange != null) {
            widget.onChange?.call(value!);
          }
        },
    );
  }

  Widget _buildProtocolText() {
    return RichText(
      text: TextSpan(
        text: S.current.userServiceAgreement,
        style: const TextStyle(fontSize: 14, color: Color(0xFF4954FF)),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {},
        children: [
          TextSpan(
              text: ' ${S.current.registerProtocolAnd} ',
              style: const TextStyle(color: Color(0xFF0D2249), fontSize: 14),
          ),
          TextSpan(
              text: S.current.privacyNotice,
              style: const TextStyle(fontSize: 14, color: Color(0xFF4954FF)),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {}),
        ],
      ),
    );
  }
}
