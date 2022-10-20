import 'package:flutter/material.dart';
import 'package:zpass/res/zpass_icons.dart';
class ZPassTextFieldWidget extends StatefulWidget {
  const ZPassTextFieldWidget({Key? key,this.controller,this.onChanged,this.icon,this.hintText,this.focusNode,this.offstageRight,this.obscureText,this.suffixIcon}) : super(key: key);
  final TextEditingController? controller;
  final Widget? icon;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final String? hintText;
  final double? offstageRight;
  final bool? obscureText;
  final Widget? suffixIcon;
  @override
  State<ZPassTextFieldWidget> createState() => _ZPassTextFieldWidgetState();
}

class _ZPassTextFieldWidgetState extends State<ZPassTextFieldWidget> {
  var val = '';
  var focus = false;
  late FocusNode focusNodeSelf;
  handelChange(value){
    if(widget.onChanged != null) {
      widget.onChanged!(value);
    };
    setState(() {
      val = value;
    });
  }
  @override
  void initState() {

    // TODO: implement initStaten
    super.initState();
    focusNodeSelf = widget.focusNode ?? FocusNode();
    focusNodeSelf.addListener(() {
      if (focusNodeSelf.hasFocus ?? false) {
        setState(() {
          val = widget.controller?.text ?? val;
          focus = true;
        });
      } else {
        setState(() {
          val = widget.controller?.text ?? val;
          focus = false;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Row(
        children: [

          Expanded(child: TextField(

            obscureText:widget.obscureText ?? false,
            focusNode:focusNodeSelf,
            controller: widget.controller,
            onChanged: handelChange,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                icon: widget.icon,
                hintText: widget.hintText,
                hintStyle:
                const TextStyle(color: Color.fromRGBO(147, 151, 157, 1)),
                border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            )),
          )),
          SizedBox(
            width: 20,
            child: Offstage(
              offstage: (val.isNotEmpty && focus )?false:true,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    val='';
                    widget.controller?.clear();
                    if(widget.onChanged != null){
                      widget.onChanged!('');
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: widget.offstageRight ?? 0),
                  width: 45,
                  height: 45,
                  child:const Icon(ZPassIcons.icXCircle,color: Colors.grey,size: 17,),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: widget.suffixIcon != null  ? 6 : 0),
            width: widget.suffixIcon != null ? 20 : 0,
            child: Offstage(
              offstage: false,
              child: widget.suffixIcon ,
            ),
          )
        ]
    );
  }
}
