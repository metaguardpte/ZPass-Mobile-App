import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/user/signin/zpass_input.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/callback_funcation.dart';

import '../../../widgets/load_image.dart';

class PswInput extends StatefulWidget {
  const PswInput({Key? key, this.onChange}) : super(key: key);
  final FunctionCallback<String>? onChange;

  @override
  State<PswInput> createState() => _PswInputState();
}

class _PswInputState extends State<PswInput> {
  late TextEditingController pswController = TextEditingController();
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
    return ZPassTextFieldWidget(

      onChanged: (value) {
        if(widget.onChange != null){
          widget.onChange!(value);
        }
        if(value == ''){
          pswController.text = value;
        }
      },
      controller: pswController,
      obscureText: !_showPasword,
      hintText: S.current.password,
      icon: const LoadAssetImage(
        'signin/LockKey@2x',
        width: 20,
        height: 20,
      ),
      suffixIcon:GestureDetector (
          behavior: HitTestBehavior.opaque,

          onTap: switchPassword,
          child: Container(
            height: 40,
            width: 30,
            alignment: Alignment.centerRight,
            child: _showPasword
                ? const Icon(ZPassIcons.icNoSecret,color: Color.fromRGBO(174, 183, 197, 1),size: 18)
                : const Icon(ZPassIcons.icSecret,color: Color.fromRGBO(174, 183, 197, 1),size: 18),
          )
      ),
    );

    //   TextField(
    //
    //
    //   decoration: InputDecoration(
    //       contentPadding: EdgeInsets.zero,
    //       suffixIcon:
    //       icon: const LoadAssetImage(
    //         'signin/LockKey@2x',
    //         width: 20,
    //         height: 20,
    //       ),

    // );
  }
}
