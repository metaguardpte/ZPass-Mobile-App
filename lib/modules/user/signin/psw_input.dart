import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/util/callback_funcation.dart';

import '../../../widgets/load_image.dart';

class PswInput extends StatefulWidget {
  const PswInput({Key? key, this.onChange}) : super(key: key);
  final FunctionCallback<String>? onChange;

  @override
  State<PswInput> createState() => _PswInputState();
}

class _PswInputState extends State<PswInput> {
  switchPassword() {
    setState(() {
      _showPasword = !_showPasword;
    });
    if (kDebugMode) {
      print('switch Password');
      print(_showPasword);
    }
  }

  var _showPasword = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        widget.onChange?.call(value);
      },
      obscureText: !_showPasword,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          suffixIcon: IconButton(
              alignment: Alignment.centerRight,
              onPressed: switchPassword,
              icon: _showPasword
                  ? const LoadAssetImage(
                      'signin/pass-on@2x',
                      width: 20,
                      height: 20,
                    )
                  : const LoadAssetImage(
                      'signin/pass-off@2x',
                      width: 20,
                      height: 20,
                    )),
          icon: const LoadAssetImage(
            'signin/LockKey@2x',
            width: 20,
            height: 20,
          ),
          hintText: S.current.password,
          hintStyle: const TextStyle(color: Color.fromRGBO(147, 151, 157, 1)),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          )),
    );
  }
}
