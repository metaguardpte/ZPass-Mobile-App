import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/vault/login/login_detail_provider.dart';
import 'package:zpass/modules/vault/vault_detail_base_state.dart';
import 'package:zpass/modules/vault/vault_item_provider.dart';

class LoginDetailPage extends StatefulWidget {
  final VaultItemEntity? data;

  const LoginDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  State<LoginDetailPage> createState() => _LoginDetailPageState();
}

class _LoginDetailPageState
    extends BaseVaultPageState<LoginDetailPage, BaseVaultProvider> {

  @override
  void initState() {
    super.initState();
    provider.analyticsData(widget.data);
  }

  @override
  String get title => S.current.tabLogins;

  @override
  BaseVaultProvider prepareProvider() {
    return LoginDetailProvider();
  }
}
