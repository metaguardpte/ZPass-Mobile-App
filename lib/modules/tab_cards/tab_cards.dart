import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';

class TabCardsPage extends StatefulWidget {
  const TabCardsPage({Key? key}) : super(key: key);

  @override
  State<TabCardsPage> createState() => _TabCardsPageState();
}

class _TabCardsPageState extends State<TabCardsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(S.current.tabCreditCards),);
  }
}
