import 'dart:async';

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
import 'package:zpass/util/toast_utils.dart';
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
  bool onSyncStatus = false;
  bool onBackupStatus = false;

  bool _unlock() {
    return !onBackupStatus && !onSyncStatus;
  }

  Future<String?> _handelSyncProviderModalShow() async {
    if (!_unlock()) {
      return Future.value(null);
    }
    Completer<String?> lock = Completer();
    pickSyncType(context, (SyncProviderType? type, index) async {

      var account = await type?.getAccount.catchError((err) {
        Toast.showError(err.toString());
      });
      Log.d('account : $account');
      if (account != null) {
        UserProvider().settings.syncAccount = account;
        _syncProviderType = type;
        setState(() {});
        lock.complete(account);
        return true;
      } else {
        lock.complete(null);
        return false;
      }
    });
    return lock.future;
  }

  BaseFileTransferManager _getFileTransferManager() {
    return GoogleDriveFileTransferManager();
  }

  _handleSync() async {
    if (_unlock()) {
      onSyncStatus = true;
      setState(() {});
      BaseFileTransferManager fileTransferManager = _getFileTransferManager();
      final userId = UserProvider().profile.data.userId;
      final action = S.current.sync;
      var unzipDBFolder =
          await fileTransferManager.download("$userId").catchError((err) {
        Log.d(
            'fileTransferManager download err -------------- > :  ${err.toString()}');
        setState(() {
          onSyncStatus = false;
        });
      });
      if (unzipDBFolder == null) {
        Toast.show('$action completed, no data online.');
        setState(() {
          onSyncStatus = false;
        });
        return;
      }
      DBSyncUnit.sync(unzipDBFolder).then((value) {
        fileTransferManager.deleteTempAssets(unzipDBFolder);
        UserProvider().settings.updateBackupDate();
        setState(() {
          onSyncStatus = false;
        });
        Toast.showSuccess('$action ${S.current.successfully}');
      }).catchError((err) {
        Log.d('DBSync sync err -------------- > :  ${err.toString()}');
        Toast.showError('$action ${S.current.failed}');
        setState(() {
          onSyncStatus = false;
        });
      });
    }
  }

  _handleBackup() {
    if (_unlock()) {
      onBackupStatus = true;
      setState(() {});
      BaseFileTransferManager fileTransferManager = _getFileTransferManager();
      var localDBPath = ZPassDB().getDBPath();
      final userId = UserProvider().profile.data.userId;
      final action = S.current.backup;
      fileTransferManager.upload(localDBPath, "$userId").then((value) {
        UserProvider().settings.updateSyncDate();
        setState(() {
          onBackupStatus = false;
        });
        Toast.showSuccess('$action ${S.current.successfully}');
      }).catchError((err) {
        Toast.showError('$action ${S.current.failed}');
        Log.d(
            'fileTransferManager upload err -------------- > :  ${err.toString()}');
        setState(() {
          onBackupStatus = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    var syncProvider = UserProvider().settings.data.syncProvider;
    if (syncProvider != null) {
      _syncProviderType = SyncProviderType.values
          .firstWhere((element) => element.name == syncProvider);
    } else {
      _syncProviderType = null;
    }
    switchType = UserProvider().settings.data.backupAndSync ?? false;
    _rightColor = const Color.fromRGBO(149, 155, 167, 1);
    _rightTextStyle = TextStyle(color: _rightColor, fontSize: 15);
    _backupAndSync = [
      RowData(
          text: S.current.backupAndSync,
          right: ListSwitch(
            defaultValue: switchType,
            onChange: (value) async {
              if (_unlock()) {
                if (value && _syncProviderType == null) {
                  var account = await _handelSyncProviderModalShow();
                  if (account != null) {
                    Log.d('account:$account');

                    switchType = value;
                    UserProvider().settings.backupAndSync = value;
                    setState(() {});
                    return value;
                  }
                  switchType = false;
                  UserProvider().settings.backupAndSync = false;
                  setState(() {});
                  return false;
                } else {
                  switchType = value;
                  UserProvider().settings.backupAndSync = value;
                  setState(() {});
                  return value;
                }
              }
              return switchType;
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
            if (_unlock()) {
              NavigatorUtils.goBackWithParams(context, {});
            }
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
      body: WillPopScope(
        onWillPop: () async {
          if (_unlock()) {
            NavigatorUtils.goBackWithParams(context, {});
          }
          return false;
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListWidget(
                flex: 3,
                rows: _backupAndSync,
                withIcon: false,
              ),
              Gaps.vGap16,
              switchType
                  ? ListWidget(
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
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 5),
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
                    )
                  : Container(),
              const Spacer(),
              (switchType && (_syncProviderType != null))
                  ? Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: _handleBackup,
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              alignment: Alignment.center,
                              height: 46,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(73, 84, 255, 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(23)),
                                  border: Border.all(
                                      width: 1,
                                      color: const Color.fromRGBO(
                                          73, 84, 255, 1))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: onBackupStatus
                                          ? const CupertinoActivityIndicator(
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
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Gaps.vGap10,
                        Text(
                          UserProvider().settings.data.backupDate != null
                              ? '${S.current.lastBackupTime} ${UserProvider().settings.data.backupDate}'
                              : '',
                          style: const TextStyle(
                              color: Color.fromRGBO(149, 155, 167, 1),
                              fontSize: 12),
                        ),
                        Gaps.vGap24,
                        Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: _handleSync,
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              alignment: Alignment.center,
                              height: 46,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(73, 84, 255, 0.0800),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(23)),
                                  border: Border.all(
                                      width: 1,
                                      color: const Color.fromRGBO(
                                          73, 84, 255, 1))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: onSyncStatus
                                          ? const CupertinoActivityIndicator(
                                              color: Color.fromRGBO(
                                                  73, 84, 255, 1),
                                              radius: 8,
                                            )
                                          : const Icon(
                                              ZPassIcons.icSync,
                                              size: 20,
                                              color: Color.fromRGBO(
                                                  73, 84, 255, 1),
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
                          UserProvider().settings.data.syncDate != null
                              ? '${S.current.lastSyncTime} ${UserProvider().settings.data.syncDate}'
                              : '',
                          style: const TextStyle(
                              color: Color.fromRGBO(149, 155, 167, 1),
                              fontSize: 12),
                        ),
                        Gaps.vGap24,
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
