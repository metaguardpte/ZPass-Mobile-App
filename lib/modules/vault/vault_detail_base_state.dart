import 'package:flutter/material.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/modules/vault/vault_item_provider.dart';

abstract class BaseVaultPageState<V extends StatefulWidget,
    P extends BaseVaultProvider> extends ProviderState<V, P> {
  String get title;

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text(title),
      actions: [
        IconButton(onPressed: onEditPress, icon: const Icon(Icons.done)),
        IconButton(onPressed: onMorePress, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  void onEditPress() {
    provider.editing = !provider.editing;
  }

  void onMorePress() {}
}
