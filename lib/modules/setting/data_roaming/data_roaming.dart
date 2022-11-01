import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/setting/data_roaming/provider/sync_provider.dart';
import 'package:zpass/modules/setting/data_roaming/sync_provider_picker.dart';
import 'package:zpass/modules/setting/switch.dart';
import 'package:zpass/modules/sync/db_sync/db_sync.dart';
import 'package:zpass/modules/sync/file_transfer/base_file_transfer.dart';
import 'package:zpass/modules/sync/file_transfer/google_drive_file_transfer.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/plugin_bridge/leveldb/zpass_db.dart';
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

class _DataRoamingPageState extends State<DataRoamingPage>
    with TickerProviderStateMixin {
  late bool switchType;
  late SyncProviderType? _syncProviderType;
  late List<RowData> _backupAndSync;
  late Color _rightColor;
  late TextStyle _rightTextStyle;
  late AnimationController _animationController;
  bool onSyncStatus = false;
  bool onBackupStatus = false;

  _handelSyncProviderModalShow() {
    pickSyncType(context, (type, index) {
      Log.d('type change ---------------------- $type');
      setState(() {
        _syncProviderType = type;
      });
    });
  }
  BaseFileTransferManager _getFileTransferManager() {
    return GoogleDriveFileTransferManager();
  }
  _handelBackup() async {
    if (!onBackupStatus) {
      BaseFileTransferManager fileTransferManager = _getFileTransferManager();
      var unzipDBFolder = await fileTransferManager.download("135").catchError((err){
        Log.d('err------------');
        Log.d(err.toString());
      });
      DBSyncUnit.sync(unzipDBFolder!);
      setState(() {
        onBackupStatus = true;
        _animationController.forward();
      });
    } else {
      setState(() {
        onBackupStatus = false;
        _animationController.stop();
      });

    }
  }
  _handelSync() {
    Log.d('sync---------------');
    if (!onSyncStatus) {
      setState(() {
        onSyncStatus = true;
        _animationController.forward();
        BaseFileTransferManager fileTransferManager = _getFileTransferManager();
        var localDBPath = ZPassDB().getDBPath();
        fileTransferManager.upload(localDBPath, "1234USER");
      });
    } else {
      onSyncStatus = false;
      _animationController.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration:const Duration(seconds: 300), vsync: this);

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
                                  padding:
                                      const EdgeInsets.only(right: 10, left: 5),
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
                onTap: _handelBackup,
                behavior: HitTestBehavior.opaque,
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
                      Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: onBackupStatus
                              ?const CupertinoActivityIndicator(
                                  color: Colors.white,
                                  radius: 8,
                                )
                              : const Icon(
                                  ZPassIcons.icSync,
                                  size: 20,
                                  color: Colors.white,
                                )),
                      // Icon(icon),
                      Text(
                        S.current.backup,
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
                onTap: _handelSync,
                behavior: HitTestBehavior.opaque,
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
                      Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: onSyncStatus
                              ?const CupertinoActivityIndicator(
                                  color: Color.fromRGBO(73, 84, 255, 1),
                                  radius: 8,
                                )
                              : const Icon(
                                  ZPassIcons.icSync,
                                  size: 20,
                                  color: Color.fromRGBO(73, 84, 255, 1),
                                )),
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

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
