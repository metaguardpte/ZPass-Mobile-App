import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/modules/vault/vault_item_provider.dart';
import 'package:zpass/res/colors.dart';
import 'package:zpass/res/styles.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/common_widgets.dart';

abstract class BaseVaultPageState<V extends StatefulWidget,
    P extends BaseVaultProvider> extends ProviderState<V, P> {
  String get emptyHint => "None";
  String get title;

  @override
  Widget buildContent(BuildContext context) {
    return Selector<P, Tuple2<bool, bool>>(
        builder: (_, tuple, __) {
          final editing = tuple.item1;
          final loading = tuple.item2;
          return Scaffold(
            appBar: buildAppBar(editing),
            body: _buildBody(editing, loading),
          );
        },
        selector: (_, provider) => Tuple2(provider.editing, provider.loading));
  }

  PreferredSizeWidget buildAppBar(bool editing) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text(title),
      actions: [
        buildEditAction(editing),
        buildPopupMenu(),
      ],
    );
  }

  Widget buildEditAction(bool editing) {
    return IconButton(
        onPressed: onEditPress,
        icon: editing
            ? const Icon(ZPassIcons.icSave)
            : const Icon(ZPassIcons.icEditing));
  }

  Widget buildPopupMenu() {
    return PopupMenuButton<int>(
      constraints: const BoxConstraints(maxWidth: 200),
      offset: const Offset(0, 15),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (_) => [
        PopupMenuItem<int>(
            enabled: false,
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OPTIONS",
              style: TextStyles.textSize14
                  .copyWith(color: const Color(0xFF818183)),
            )),
        const PopupMenuDivider(height: 1,),
        PopupMenuItem<int>(
            height: 37.5,
            value: 1,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Text("Delete", style: TextStyles.textSize14.copyWith(color: Colours.app_error),)),
                const Icon(Icons.remove_circle_outline, size: 15, color: Colours.app_error,),
              ],
            )),
      ],
      onSelected: (int item) => onMenuPress(item),
      // child: IconButton(onPressed: onMorePress, icon: const Icon(ZPassIcons.icOperate)),
    );
  }

  Widget _buildBody(bool editing, bool loading) {
    return Stack(
      children: [
        buildBody(editing),
        Visibility(visible: loading, child: commonLoading(context))
      ],
    );
  }

  Widget buildBody(bool editing);

  void onEditPress() {
    provider.editing = !provider.editing;
  }

  void onMorePress() {}

  void onMenuPress(int index) {
    switch (index) {
      case 1:
        //delete
        provider.removeData().then((succeed) {
          if (succeed) {
            Toast.show("Item deleted: ${provider.entity?.name ?? ""}");
            NavigatorUtils.goBackWithParams(context, {"changed": true});
          } else {
            Toast.showError("Failed to delete");
          }
        }).catchError((e) {
          Toast.showError("Failed to delete: $e");
        });
        break;
      default:
        Log.d("not processed menu: $index", tag: "VaultDetailBaseState");
    }
  }
}
