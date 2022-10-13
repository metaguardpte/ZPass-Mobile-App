import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';

class TabNotesPage extends StatefulWidget {
  const TabNotesPage({Key? key}) : super(key: key);

  @override
  State<TabNotesPage> createState() => _TabNotesPageState();
}

class _TabNotesPageState extends State<TabNotesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(S.current.tabSecureNotes),);
  }
}
