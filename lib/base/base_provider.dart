import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

/// BaseProvide
class BaseProvider with ChangeNotifier {
  CompositeSubscription compositeSubscription = CompositeSubscription();

  /// add [StreamSubscription] to [compositeSubscription]
  ///
  /// dispose subscriptions in [dispose]
  addSubscription(StreamSubscription subscription){
    compositeSubscription.add(subscription);
  }

  @override
  void dispose() {
    super.dispose();
    compositeSubscription.dispose();
  }
}

abstract class ProviderState<T extends StatefulWidget, P extends BaseProvider> extends State<T> {
  late P provider;

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    provider = prepareProvider();
  }

  /// Child must prepare provider here
  @protected
  P prepareProvider();

  @protected
  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<P>.value(
      value: provider,
      child: buildContent(context),
    );
  }

  // @override
  // void dispose() {
  //   provider.dispose();
  //   super.dispose();
  // }
}

abstract class AliveProviderState<T extends StatefulWidget,
        P extends BaseProvider> extends ProviderState<T, P>
    with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<P>.value(
      value: provider,
      child: buildContent(context),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

mixin TabPageFocusable {
  void onFocusChanged(bool isFocus);
}