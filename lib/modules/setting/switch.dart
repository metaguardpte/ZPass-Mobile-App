import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpass/util/callback_funcation.dart';

class ListSwitch extends StatefulWidget {
  const ListSwitch({Key? key,this.defaultValue, this.onChange}) : super(key: key);
  final bool? defaultValue;
  final FunctionReturn<Future<bool?>, bool>? onChange;
  @override
  State<ListSwitch> createState() => _ListSwitchState();
}

class _ListSwitchState extends State<ListSwitch> {
  late bool _switchType;
  @override
  void initState() {
    super.initState();
    _switchType = widget.defaultValue ?? false;
  }
  @override
  Widget build(BuildContext context) {

    return CupertinoSwitch(
      thumbColor: Colors.white,
      activeColor:const Color.fromRGBO(73, 84, 255, 1),
      trackColor: const Color.fromRGBO(232, 232, 232,1),
      onChanged: (type) async {
        if (widget.onChange != null) {
          bool? result = await widget.onChange?.call(type);
          if (result == null) return;
          if (result != _switchType) {
            setState(() {
              _switchType = result;
            });
          }
        } else {
          _switchType = type;
          setState(() {});
        }
      },value: _switchType,);
  }
}
