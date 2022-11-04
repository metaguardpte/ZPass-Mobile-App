import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/setting/data_roaming/provider/sync_provider.dart';
import 'package:zpass/modules/setting/router_settting.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/log_utils.dart';
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
  late SyncProviderType? _syncProviderType;
  _handelNavToDataRoamingSetting(){
    // NavigatorUtils.pushResult(context, RouterScanner.scanner, _parseScanCodeResult);
    NavigatorUtils.pushResult(context, RouterSetting.dataRoaming,(dynamic data){
      initSync();
      setState(() {});
    });
  }
  void initSync(){
    var syncProvider = UserProvider().settings.data.syncProvider;
    var syncType = UserProvider().settings.data.backupAndSync;
    Log.d('provider:${syncProvider} syncType:${syncType}');
    if (syncProvider != null && (syncType ?? false)) {
      _syncProviderType = SyncProviderType.values
          .firstWhere((element) => element.name == syncProvider);
    } else {
      _syncProviderType = null;
    }
  }
  @override
  void initState() {
    super.initState();
    initSync();
  }
  @override
  Widget build(BuildContext context) {
    List<RowData> rowData = [
      // RowData(
      //     text: S.current.Language,
      //     icon: const Icon(
      //       ZPassIcons.icLanguage,
      //       size: 18,
      //     ),
      //     right: Row(
      //       children: [
      //         const Spacer(),
      //         Padding(
      //             padding: const EdgeInsets.only(right: 10),
      //             child: Material(
      //                 child: Text(
      //               'English',
      //               style: widget.rightStyle,
      //             ))),
      //         Icon(
      //           ZPassIcons.icArrowRight,
      //           color: widget.rightColor,
      //           size: 10,
      //         )
      //       ],
      //     )),
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
              children: _syncProviderType != null ? [
                const Spacer(),
                _syncProviderType?.icon ?? Container(),
                Padding(
                    padding: const EdgeInsets.only(
                        right: 10, left: 5),
                    child: Material(
                        child: Text(
                          _syncProviderType?.desc ?? '',
                          style: widget.rightStyle,
                        ))),
                Icon(
                  ZPassIcons.icArrowRight,
                  color: widget.rightColor,
                  size: 10,
                )
              ] : [
                const Spacer(),
                Padding(
                    padding: const EdgeInsets.only(
                        right: 10, left: 5),
                    child: Material(
                        child: Text(
                          S.current.off,
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
      // RowData(
      //     text: S.current.Clipboard,
      //     icon: const Icon(
      //       ZPassIcons.icClipboard,
      //       size: 18,
      //     ),
      //     right: Row(
      //       children: [
      //         const Spacer(),
      //         Padding(
      //             padding: const EdgeInsets.only(right: 10),
      //             child: Material(
      //                 child: Text(
      //               'Never',
      //               style: widget.rightStyle,
      //             ))),
      //         Icon(
      //           ZPassIcons.icArrowRight,
      //           color: widget.rightColor,
      //           size: 10,
      //         )
      //       ],
      //     )),
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
