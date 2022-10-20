import 'package:flutter/material.dart';
import 'package:zpass/modules/home/model/vault_item_wrapper.dart';
import 'package:zpass/modules/home/provider/tab_vault_item_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/home/tabs/tab_base_state.dart';
import 'package:zpass/modules/home/tabs/tab_widget_helper.dart';

class TabIdentitiesPage extends StatefulWidget {
  const TabIdentitiesPage({Key? key}) : super(key: key);

  @override
  State<TabIdentitiesPage> createState() => _TabIdentitiesPageState();
}

class _TabIdentitiesPageState extends TabBasePageState<TabIdentitiesPage,
    VaultItemWrapper, TabVaultItemProvider> {
  @override
  String get emptyTips => "No Identities";

  @override
  String get emptyImage => "home/empty_infos";

  @override
  TabVaultItemProvider prepareProvider() {
    return TabVaultItemProvider(type: VaultItemType.identity);
  }

  @override
  Widget buildListItem(BuildContext context, VaultItemWrapper element) => renderListItem(context, element);

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
}
