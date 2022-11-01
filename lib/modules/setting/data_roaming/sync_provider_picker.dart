import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/setting/data_roaming/provider/sync_provider.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/widgets/dialog/zpass_picker_dialog.dart';


class SyncProviderPicker extends ZPassPickerDialog<SyncProviderType> {
  SyncProviderPicker(
      {required super.data, required super.onItemSelected, super.title,this.onSelect})
      : super(name: "SyncProviderPicker");
  final SyncProviderType? onSelect;
  @override
  Widget renderItem(BuildContext context, SyncProviderType item, int index) {
    return Container(
      margin:const EdgeInsets.only(left: 24,right: 24),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(235, 235, 235, 0.7),
            width: 0.5,
          ),
        ),
      ),
      height: 53,
      child: Row(
        children: [
          item.icon,
          Gaps.hGap12,
          Text(
            item.desc,
            style: const TextStyle(color: Color(0xFF16181A), fontSize: 18),
          ),
          const Spacer(),
          onSelect?.name == item.name ? const Icon(
            Icons.check,
            color: Color.fromRGBO(73, 84, 255, 1),
            size: 22,
          ) : Container()
        ],
      ),
    );
  }
}

void pickSyncType(BuildContext context,Function onChange) {
  final data = SyncProviderType.values.sublist(0, 4);
  itemSelected(SyncProviderType type, index) {
    Log.d("pick vault item type: $type");
    UserProvider().settings.syncProvider = type.name;
    onChange(type,index);
  }
  var syncProvider = UserProvider().settings.data.syncProvider;
  SyncProviderType? onSelect;
  Log.d('-------------syncProvider-------------');
  Log.d(syncProvider ?? "syncProvider none");
  if(syncProvider != null){
    onSelect = SyncProviderType.values.firstWhere((element) => element.name == syncProvider);
  }
  SyncProviderPicker(data: data, onItemSelected: itemSelected, title: S.current.syncProvider,onSelect:onSelect)
      .show(context);
}
