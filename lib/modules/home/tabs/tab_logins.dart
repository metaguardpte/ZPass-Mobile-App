import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:zpass/extension/int_ext.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/provider/tab_vault_item_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_sort_type.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/home/tabs/tab_base_state.dart';
import 'package:zpass/util/date_utils.dart';
import 'package:zpass/util/theme_utils.dart';

class TabLoginsPage extends StatefulWidget {
  const TabLoginsPage({Key? key}) : super(key: key);

  @override
  State<TabLoginsPage> createState() => _TabLoginsPageState();
}

class _TabLoginsPageState extends TabBasePageState<TabLoginsPage,
    VaultItemEntity, TabVaultItemProvider> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchData(reset: true);
    });
  }

  @override
  String get emptyTips => "No Logins";

  @override
  TabVaultItemProvider prepareProvider() {
    return TabVaultItemProvider(type: VaultItemType.login);
  }

  Widget _buildListItemContent(BuildContext context, VaultItemEntity element) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(9)),
              child: Transform.rotate(
                angle: 45 * math.pi / 180,
                child: const Icon(
                  Icons.key,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      title: Text(element.name),
      subtitle: Text(element.description),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.arrow_forward_ios, color: Color(0xFFC8CDD7), size: 15,)
        ],
      ),
    );
  }

  @override
  Widget buildListItem(BuildContext context, VaultItemEntity element) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.tertiaryBackground,
        ),
        child: _buildListItemContent(context, element));
  }

  @override
  Widget buildListGroupItem(BuildContext context, VaultItemEntity element, bool groupStart, bool groupEnd) {
    BorderRadiusGeometry? radius;
    if (groupStart) {
      radius = const BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11));
    } else if (groupEnd) {
      radius = const BorderRadius.only(bottomLeft: Radius.circular(11), bottomRight: Radius.circular(11));
    }
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration:
            BoxDecoration(color: context.tertiaryBackground, borderRadius: radius),
        child: _buildListItemContent(context, element));
  }

  @override
  int comparator(VaultItemEntity e1, VaultItemEntity e2) {
    switch (provider.sortType) {
      case VaultItemSortType.lastUsed:
        return e1.useTime.compareTo(e2.useTime);
      case VaultItemSortType.createTime:
        return e1.createTime.compareTo(e2.createTime);
    }
  }

  @override
  String listGroupBy(VaultItemEntity element) {
    switch (provider.sortType) {
      case VaultItemSortType.lastUsed:
        return element.useTime.formatDateTime(format: dateFormat_Y_M_D);
      case VaultItemSortType.createTime:
        return element.createTime.formatDateTime(format: dateFormat_Y_M_D);
    }
  }
}
