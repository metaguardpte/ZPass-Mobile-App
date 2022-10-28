import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/setting/router_settting.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/widgets/list.dart';

class GeneralWidget extends StatefulWidget {
  const GeneralWidget(
      {Key? key, required this.rightStyle, required this.rightColor})
      : super(key: key);
  final TextStyle rightStyle;
  final Color rightColor;

  @override
  State<GeneralWidget> createState() => _GeneralWidgetState();
}

class _GeneralWidgetState extends State<GeneralWidget> {
  _handelNavToDataRoamingSetting(){
    NavigatorUtils.push(context, RouterSetting.dataRoaming);
  }
  @override
  Widget build(BuildContext context) {
    List<RowData> rowData = [
      RowData(
          text: S.current.Language,
          icon: const Icon(
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
          text: S.current.DataRoaming,
          icon: const Icon(
            ZPassIcons.icDataRoaming,
            size: 18,
          ),
          right: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handelNavToDataRoamingSetting,
            child: Row(
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
            ),
          )),
      RowData(
          text: S.current.Clipboard,
          icon: const Icon(
            ZPassIcons.icClipboard,
            size: 18,
          ),
          right: Row(
            children: [
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Material(
                      child: Text(
                    'Never',
                    style: widget.rightStyle,
                  ))),
              Icon(
                ZPassIcons.icArrowRight,
                color: widget.rightColor,
                size: 10,
              )
            ],
          )),
    ];
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.only(top: 16),
          child: Material(
            color: Colors.transparent,
            child: Text(
              S.current.General,
              style: const TextStyle(
                  color: Color.fromRGBO(149, 155, 167, 1), fontSize: 14),
            ),
          ),
        ),
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
