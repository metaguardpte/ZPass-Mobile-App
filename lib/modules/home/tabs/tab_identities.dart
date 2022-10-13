import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';

class TabIdentitiesPage extends StatefulWidget {
  const TabIdentitiesPage({Key? key}) : super(key: key);

  @override
  State<TabIdentitiesPage> createState() => _TabIdentitiesPageState();
}

class _TabIdentitiesPageState extends State<TabIdentitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(S.current.tabIdentities),);
  }
}
