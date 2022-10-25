import 'package:flutter/material.dart';
import 'package:zpass/modules/home/model/vault_item_wrapper.dart';
import 'package:zpass/modules/home/provider/tab_vault_item_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_sort_type.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/home/tabs/tab_base_state.dart';
import 'package:zpass/modules/home/tabs/tab_widget_helper.dart';

class TabLoginsPage extends StatefulWidget {
  const TabLoginsPage({Key? key}) : super(key: key);

  @override
  State<TabLoginsPage> createState() => _TabLoginsPageState();
}

class _TabLoginsPageState extends TabBasePageState<TabLoginsPage,
    VaultItemWrapper, TabVaultItemProvider> {

  @override
  String get emptyTips => "No Logins";

  @override
  String get emptyImage => "home/empty_logins";

  @override
  TabVaultItemProvider prepareProvider() {
    return TabVaultItemProvider(type: VaultItemType.login);
  }

  @override
  Widget buildListItem(BuildContext context, VaultItemWrapper element) => renderListItem(context, element);

  @override
  Widget buildListGroupItem(BuildContext context, VaultItemWrapper element,
          bool groupStart, bool groupEnd) =>
      renderListGroupItem(context, element, groupStart, groupEnd);

  @override
  int comparator(VaultItemWrapper e1, VaultItemWrapper e2) {
    switch (provider.sortType) {
      case VaultItemSortType.lastUsed:
        if (e1.raw.useTime == null || e2.raw.useTime == null) return 1;
        return e1.raw.useTime!.compareTo(e2.raw.useTime!);
      case VaultItemSortType.createTime:
        return e1.raw.createTime.compareTo(e2.raw.createTime);
    }
  }

  @override
  String listGroupBy(VaultItemWrapper element) {
    return element.groupName;
  }

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }
}
