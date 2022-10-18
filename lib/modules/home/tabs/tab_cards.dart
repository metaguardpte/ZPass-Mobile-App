import 'package:flutter/material.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/provider/tab_vault_item_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/home/tabs/tab_base_state.dart';

class TabCardsPage extends StatefulWidget {
  const TabCardsPage({Key? key}) : super(key: key);

  @override
  State<TabCardsPage> createState() => _TabCardsPageState();
}

class _TabCardsPageState extends TabBasePageState<TabCardsPage, VaultItemEntity,
    TabVaultItemProvider> {
  @override
  String get emptyTips => "No Cards";

  @override
  TabVaultItemProvider prepareProvider() {
    return TabVaultItemProvider(type: VaultItemType.credit);
  }

  @override
  Widget buildListItem(BuildContext context, VaultItemEntity element) {
    return ListTile(title: Text(element.name), subtitle: Text(element.description),);
  }

  @override
  int comparator(VaultItemEntity e1, VaultItemEntity e2) {
    return 1;
  }

  @override
  String listGroupBy(VaultItemEntity element) {
    return "Cards";
  }
}
