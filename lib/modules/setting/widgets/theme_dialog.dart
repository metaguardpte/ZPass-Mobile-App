import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpass/modules/setting/provider/theme_provider.dart';
import 'package:zpass/widgets/content_align_bottom_dialog.dart';

class ThemeDialog extends ContentAlignBottomDialog {
  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: Text(ThemeMode.light.value),
            onTap: () => _switchTheme(context, ThemeMode.light),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(ThemeMode.dark.value),
            onTap: () => _switchTheme(context, ThemeMode.dark),
          ),
          ListTile(
            title: const Center(child: Text("Cancel")),
            onTap: () => dismiss(context),
          ),
        ]
      ).toList(),
    );
  }

  void _switchTheme(BuildContext context, ThemeMode mode) {
    context.read<ThemeProvider>().setTheme(mode);
    dismiss(context);
  }
}