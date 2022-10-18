import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListSwitch extends StatefulWidget {
  const ListSwitch({Key? key,this.defaultValue,required this.onChange}) : super(key: key);
  final bool? defaultValue;
  final Function onChange;
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
      onChanged: (type){
        _switchType = type;
        setState(() {});
      },value: _switchType,);
  }
}
