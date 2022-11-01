import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:zpass/modules/vault/cards/cards_detail_page.dart';
import 'package:zpass/modules/vault/login/login_detail_page.dart';
import 'package:zpass/modules/vault/secure_notes/secure_notes_page.dart';
import 'package:zpass/routers/i_router.dart';

class RoutersVault extends IRouterProvider {
  static const String vaultDetailLogin = "/home/vault/login";
  static const String vaultDetailCards = "/home/vault/cards";
  static const String vaultSecureNotes = "/home/vault/secureNotes";

  @override
  void initRouter(FluroRouter router) {
    router.define(vaultDetailLogin, handler: Handler(handlerFunc: (context, _) {
      final args = ModalRoute.of(context!)?.settings.arguments as Map<String, dynamic>?;
      final item = args != null ? args["item"] : null;
      return LoginDetailPage(data: item,);
    }));
    router.define(vaultDetailCards, handler: Handler(handlerFunc: (context, _) {
      final args = ModalRoute.of(context!)?.settings.arguments as Map<String, dynamic>?;
      final item = args != null ? args["item"] : null;
      return CardsDetailPage(data: item,);
    }));
    router.define(vaultSecureNotes,
        handler: Handler(handlerFunc: (_, __) => const SecureNotesPage()));

  }
}
