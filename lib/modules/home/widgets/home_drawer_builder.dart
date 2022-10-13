import 'package:flutter/material.dart';
import 'package:zpass/modules/home/widgets/home_widget_builder.dart';
import 'package:zpass/util/theme_utils.dart';

class HomeDrawerBuilder extends HomeWidgetBuilder {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.primaryColor,
            ),
            child: const Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.message),
            title: Text('Language'),
          ),
          const ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Theme'),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }

}