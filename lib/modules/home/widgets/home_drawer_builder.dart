import 'package:flutter/material.dart';
import 'package:zpass/modules/home/home_page_v2.dart';
import 'package:zpass/modules/home/widgets/home_widget_builder.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/theme_utils.dart';

class HomeDrawerBuilder extends HomeWidgetBuilder {
  final FunctionCallback<HomePageAction> onActionCallback;

  HomeDrawerBuilder(this.onActionCallback);

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
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(HomePageAction.locale.name),
            onTap: () => _navigate(context, HomePageAction.locale),
          ),
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: Text(HomePageAction.theme.name),
            onTap: () => _navigate(context, HomePageAction.theme),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, HomePageAction action) {
    Log.d("navigate to ${action.name}", tag: "HomeDrawerBuilder");
    onActionCallback.call(action);
  }
}