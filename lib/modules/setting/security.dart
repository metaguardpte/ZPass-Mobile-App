import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/setting/switch.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/widgets/list.dart';

class SecurityWidget extends StatefulWidget {
  const SecurityWidget({Key? key,required this.rightStyle,required this.rightColor}) : super(key: key);
  final TextStyle rightStyle;
  final Color rightColor;

  @override
  State<SecurityWidget> createState() => _SecurityWidgetState();
}

class _SecurityWidgetState extends State<SecurityWidget> {
  @override
  Widget build(BuildContext context) {
    List<RowData> rowData = [
      RowData(
          text: S.current.AutoLock,
          icon:const Icon(
            ZPassIcons.icLanguage,
            size: 18,
          ),
          right: Row(
            children: [
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Material(
                      child: Text(
                        'English',
                        style: widget.rightStyle,
                      ))),
              Icon(
                ZPassIcons.icArrowRight,
                color: widget.rightColor,
                size: 10,
              )
            ],
          )),
      RowData(
          text: S.current.seKey,
          icon:const Icon(
            ZPassIcons.icDataRoaming,
            size: 18,
          ),
          right: Row(
            children: [
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Material(
                      child: Text(
                        'OFF',
                        style: widget.rightStyle,
                      ))),
              Icon(
                ZPassIcons.icArrowRight,
                color: widget.rightColor,
                size: 10,
              )
            ],
          )),
      RowData(
          text: S.current.UnlockWithFinger,
          icon:const Icon(
            ZPassIcons.icClipboard,
            size: 18,
          ),
          right: ListSwitch(onChange: (){

          },)
      ),
      RowData(
          text: S.current.UnlockWithFace,
          icon:const Icon(
            ZPassIcons.icClipboard,
            size: 18,
          ),
          right: ListSwitch(onChange: (){

          },)
      ),
    ];
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          margin:const EdgeInsets.only(top: 16),
          child: Material(color: Colors.transparent,child: Text(S.current.General,style: const TextStyle(
            color: Color.fromRGBO(149, 155, 167, 1),
            fontSize: 14
          ),),),),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: ListWidget(
            rows: rowData,
          ),
        )
      ],
    );
  }
}
