import 'package:flutter/cupertino.dart';
import 'package:zpass/util/log_utils.dart';

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    String currentPage = pageName(previousRoute);
    if (currentPage.isNotEmpty) {
      Log.d("didPush currentPage: $currentPage", tag: "RouteObserver");
    }

    String targetPage = pageName(route);
    if (targetPage.isNotEmpty) {
      Log.d("didPush targetPage: $targetPage", tag: "RouteObserver");
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    String currentPage = pageName(route);
    if (currentPage.isNotEmpty) {
      Log.d("didPop currentPage: $currentPage", tag: "RouteObserver");
    }
    String targetPage = pageName(previousRoute);
    if (targetPage.isNotEmpty) {
      Log.d("didPop targetPage: $targetPage", tag: "RouteObserver");
    }
  }

  String pageName(Route? route) {
    return "router-${route?.settings.name ?? "unknown"}";
  }
}