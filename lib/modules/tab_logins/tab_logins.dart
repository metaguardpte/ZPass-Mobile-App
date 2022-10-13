import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';

class TabLoginsPage extends StatefulWidget {
  const TabLoginsPage({Key? key}) : super(key: key);

  @override
  State<TabLoginsPage> createState() => _TabLoginsPageState();
}

class _TabLoginsPageState extends State<TabLoginsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(S.current.tabLogins),);
  }
}
