import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';

class NotFoundPage extends StatelessWidget {

  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.errorPageNotFound),
        centerTitle: true,
      ),
      body: Center(
        child: Text(S.current.errorPageNotFound),
      ),
    );
  }
}
