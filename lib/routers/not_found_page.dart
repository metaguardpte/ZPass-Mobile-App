import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/zpass_localizations.dart';

class NotFoundPage extends StatelessWidget {

  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ZPassLocalizations.of(context)!.errorPageNotFound),
        centerTitle: true,
      ),
      body: Center(
        child: Text(ZPassLocalizations.of(context)!.errorPageNotFound),
      ),
    );
  }
}
