import 'package:flutter/material.dart';

class TabMePage extends StatefulWidget {
  const TabMePage({Key? key}) : super(key: key);

  @override
  State<TabMePage> createState() => _TabMePageState();
}

class _TabMePageState extends State<TabMePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Me"),);
  }
}
