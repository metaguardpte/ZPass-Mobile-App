import 'package:flutter/material.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/provider/tab_vault_item_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/home/tabs/tab_base_state.dart';

class TabNotesPage extends StatefulWidget {
  const TabNotesPage({Key? key}) : super(key: key);

  @override
  State<TabNotesPage> createState() => _TabNotesPageState();
}

class _TabNotesPageState extends TabBasePageState<TabNotesPage, VaultItemEntity,
    TabVaultItemProvider> {
  @override
  String get emptyTips => "No Notes";

  @override
  TabVaultItemProvider prepareProvider() {
    return TabVaultItemProvider(type: VaultItemType.note);
  }

  @override
  Widget buildListItem(BuildContext context, VaultItemEntity element) {
    return ListTile(title: Text(element.name), subtitle: Text(element.description ?? ""),);
  }

  @override
  int comparator(VaultItemEntity e1, VaultItemEntity e2) {
    return 1;
  }

  @override
  String listGroupBy(VaultItemEntity element) {
    return "Notes";
  }
}
