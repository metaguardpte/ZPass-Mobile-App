import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/setting/data_roaming/provider/sync_provider.dart';
import 'package:zpass/modules/setting/data_roaming/sync_provider_picker.dart';
import 'package:zpass/modules/setting/switch.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/widgets/list.dart';

class DataRoamingPage extends StatefulWidget {
  const DataRoamingPage({Key? key}) : super(key: key);

  @override
  State<DataRoamingPage> createState() => _DataRoamingPageState();
}

class _DataRoamingPageState extends State<DataRoamingPage> {
  late bool switchType;
  late SyncProviderType? _syncProviderType;
  late List<RowData> _backupAndSync;
  late Color _rightColor;
  late TextStyle _rightTextStyle;

  _handelSyncProviderModalShow() {
    pickSyncType(context, (type, index) {
      Log.d('type change ---------------------- $type');
      setState(() {
        _syncProviderType = type;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    var syncProvider = UserProvider().userSetting.syncProvider;
    if (syncProvider != null) {
      _syncProviderType = SyncProviderType.values
          .firstWhere((element) => element.name == syncProvider);
    } else {
      _syncProviderType = null;
    }
    switchType = UserProvider().userSetting.backupAndSync ?? false;
    _rightColor = const Color.fromRGBO(149, 155, 167, 1);
    _rightTextStyle = TextStyle(color: _rightColor, fontSize: 15);
    _backupAndSync = [
      RowData(
          text: S.current.backupAndSync,
          right: ListSwitch(
            defaultValue: switchType,
            onChange: (value) async {
              setState(() {
                switchType = value;
                UserProvider().backupAndSync = value;
              });
              return value;
            },
          ))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.current.DataRoaming,
          style: const TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            NavigatorUtils.goBack(context);
          },
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              ZPassIcons.icNavBack,
              color: Color.fromRGBO(94, 99, 103, 1),
              size: 16,
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListWidget(
              flex: 3,
              rows: _backupAndSync,
              withIcon: false,
            ),
            Gaps.vGap16,
            ListWidget(
              flex: 2,
              rows: [
                RowData(
                    text: S.current.syncProvider,
                    right: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _handelSyncProviderModalShow,
                        child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          height: 50,
                          child: Row(
                            children: [
                              const Spacer(),
                              _syncProviderType?.icon ?? Container(),
                              Padding(
                                  padding: const EdgeInsets.only(right: 10, left: 5),
                                  child: Material(
                                      child: Text(
                                        _syncProviderType?.desc ?? '',
                                        style: _rightTextStyle,
                                      ))),
                              Icon(
                                ZPassIcons.icArrowRight,
                                color: _rightColor,
                                size: 10,
                              )
                            ],
                          ),
                        )))
              ],
              withIcon: false,
            ),
            const Spacer(),
            Container(
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  height: 46,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(73, 84, 255, 1),
                      borderRadius: const BorderRadius.all(Radius.circular(23)),
                      border: Border.all(
                          width: 1,
                          color: const Color.fromRGBO(73, 84, 255, 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(icon),
                      Text(
                        S.current.sync,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Gaps.vGap10,
            Text(
              S.current.lastSyncTime,
              style: const TextStyle(
                  color: Color.fromRGBO(149, 155, 167, 1), fontSize: 12),
            ),
            Gaps.vGap24,
            Container(
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  height: 46,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(73, 84, 255, 0.0800),
                      borderRadius: const BorderRadius.all(Radius.circular(23)),
                      border: Border.all(
                          width: 1,
                          color: const Color.fromRGBO(73, 84, 255, 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(icon),
                      Text(
                        S.current.sync,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color.fromRGBO(73, 84, 255, 1),
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Gaps.vGap10,
            Text(
              S.current.lastSyncTime,
              style: const TextStyle(
                  color: Color.fromRGBO(149, 155, 167, 1), fontSize: 12),
            ),
            Gaps.vGap24,
          ],
        ),
      ),
    );
  }
}