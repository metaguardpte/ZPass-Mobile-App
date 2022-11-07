import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/model/vault_item_wrapper.dart';
import 'package:zpass/modules/home/provider/tab_vault_item_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/home/tabs/tab_base_state.dart';
import 'package:zpass/modules/home/tabs/tab_widget_helper.dart';
import 'package:zpass/modules/vault/vault_routers.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/log_utils.dart';

class TabNotesPage extends StatefulWidget {
  const TabNotesPage({Key? key}) : super(key: key);

  @override
  State<TabNotesPage> createState() => _TabNotesPageState();
}

class _TabNotesPageState extends TabBasePageState<TabNotesPage,
    VaultItemWrapper, TabVaultItemProvider> {
  @override
  String get emptyTips => S.current.noSecureNotes;

  @override
  String get emptyImage => "home/empty_notes";

  @override
  TabVaultItemProvider prepareProvider() {
    return TabVaultItemProvider(type: VaultItemType.note);
  }

  @override
  Widget buildListItem(BuildContext context, VaultItemWrapper element) =>
      renderListItem(context, element);

  @override
  Widget buildListGroupItem(BuildContext context, VaultItemWrapper element,
          bool groupStart, bool groupEnd) =>
      renderListGroupItem(context, element, groupStart, groupEnd);

  @override
  int comparator(VaultItemWrapper e1, VaultItemWrapper e2) {
    return 1;
  }

  @override
  String listGroupBy(VaultItemWrapper element) {
    return element.groupName;
  }

  @override
  void onItemClicked(VaultItemWrapper item) {
    NavigatorUtils.pushResult(context, RoutersVault.vaultSecureNotes,
        (dynamic result) {
      Log.d(
          "${RoutersVault.vaultDetailLogin} router result: ${result?.toString()}",
          tag: "TabLoginsPageState");
      if (result["changed"] == true) {
        provider.fetchData(reset: true);
      }
    }, arguments: {"item": item.raw});
  }
}
