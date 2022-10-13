import 'package:flutter/material.dart';
import 'package:zpass/util/callback_funcation.dart';

import '../../widgets/load_image.dart';

class SwitchFlash extends StatefulWidget {
  const SwitchFlash({Key? key,this.switchFlash}) : super(key: key);
  final FunctionCallback<bool>? switchFlash;
  @override
  State<SwitchFlash> createState() => _SwitchFlashState();
}

class _SwitchFlashState extends State<SwitchFlash> {
  bool _switchFlash = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        setState(() {
          _switchFlash = !_switchFlash;
        });
        widget.switchFlash?.call(_switchFlash);
      },
      child: Container(
        alignment: Alignment.topRight,
        width: 30,
        height: 30,
        child: _switchFlash
            ? const LoadAssetImage('signin/light-on@2x', width: 26, height: 26)
            : const LoadAssetImage('signin/light-off@2x', width: 26, height: 26),
      ),
    );
  }
}
