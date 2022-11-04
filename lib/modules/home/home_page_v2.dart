import 'dart:convert';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/provider/home_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/home/tabs/tab_base_state.dart';
import 'package:zpass/modules/home/widgets/home_app_bar_builder.dart';
import 'package:zpass/modules/home/widgets/home_bottom_bar_builder.dart';
import 'package:zpass/modules/home/tabs/tab_cards.dart';
import 'package:zpass/modules/home/tabs/tab_identities.dart';
import 'package:zpass/modules/home/tabs/tab_logins.dart';
import 'package:zpass/modules/home/tabs/tab_notes.dart';
import 'package:zpass/modules/home/widgets/home_drawer_builder.dart';
import 'package:zpass/modules/scanner/router_scanner.dart';
import 'package:zpass/modules/setting/router_settting.dart';
import 'package:zpass/modules/setting/widgets/locale_dialog.dart';
import 'package:zpass/modules/setting/widgets/theme_dialog.dart';
import 'package:zpass/modules/user/router_user.dart';
import 'package:zpass/modules/user/signin/signin_by_scanner.dart';
import 'package:zpass/modules/vault/vault_item_picker.dart';
import 'package:zpass/modules/vault/vault_routers.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/double_tap_back_exit_app.dart';

class HomePageV2 extends StatefulWidget {
  static const int dockedFake = 2;

  const HomePageV2({Key? key}) : super(key: key);

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

enum HomePageAction {
  create,
  scan,
  message,
  setting,
  locale,
  theme,
}

class _HomePageV2State extends ProviderState<HomePageV2, HomeProvider> with WidgetsBindingObserver {
  late final List<TabItem> _items;
  late final List<Widget> _pageList;
  late final PageController _pageController = PageController();
  late final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _tabLoginsKey = GlobalKey<TabBasePageState>();
  final _tabNotesKey = GlobalKey<TabBasePageState>();
  final _tabCardsKey = GlobalKey<TabBasePageState>();
  final _tabIdentitiesKey = GlobalKey<TabBasePageState>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _items = <TabItem>[
      TabItem(icon: ZPassIcons.logins, activeIcon: ZPassIcons.loginsActive, title: S.current.tabLogins),
      TabItem(icon: ZPassIcons.secureNotes, activeIcon: ZPassIcons.secureNotesActive, title: S.current.tabSecureNotes),
      const TabItem(icon: Icons.add_rounded, title: "Fake"),
      TabItem(icon: ZPassIcons.creditCards, activeIcon: ZPassIcons.creditCardsActive, title: S.current.tabCreditCards),
      TabItem(icon: ZPassIcons.identities, activeIcon: ZPassIcons.identitiesActive, title: S.current.tabIdentities),
    ];
    _pageList = [
      TabLoginsPage(key: _tabLoginsKey),
      TabNotesPage(key: _tabNotesKey),
      Container(),
      TabCardsPage(key: _tabCardsKey),
      TabIdentitiesPage(key: _tabIdentitiesKey),
    ];
    Future.delayed(const Duration(seconds: 2), () => SyncTask.run());
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Log.d("APP State: ${state.toString()}", tag: "AppLifecycleState");
    if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.paused) {
      provider.repoDB.flush();
    } else if (state == AppLifecycleState.detached) {
      provider.repoDB.close();
    } else {

    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget buildContent(BuildContext context) {
    return DoubleTapBackExitApp(
      backConsumer: _onBackPress,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: HomeAppBarBuilder(_onActionPerform).build(context),
        resizeToAvoidBottomInset: false,
        backgroundColor: context.backgroundColor,
        endDrawer: HomeDrawerBuilder(_onActionPerform).build(context),
        body: _buildPageView(),
        bottomNavigationBar: _buildAppNavigationBar(),
      ),
    );
  }

  Widget _buildAppNavigationBar() {
    return ConvexAppBar.builder(
      itemBuilder: HomeBottomBarBuilder(_items, context.backgroundColor),
      count: _items.length,
      backgroundColor: context.groupBackground,
      onTapNotify: (i) {
        var intercept = i == HomePageV2.dockedFake;
        if (intercept) {
          VaultItemPicker(
              data: VaultItemType.values.sublist(0, 3),
              onItemSelected: _onVaultItemTap,
              title: "Items")
              .show(context);
        }
        return !intercept;
      },
      onTap: (int index) => _pageController.jumpToPage(index),
      shadowColor: const Color(0x408792a4),
      elevation: 2,
      height: 55,
      top: -20,
    );
  }

  Widget _buildPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(), // 禁止滑动
      controller: _pageController,
      onPageChanged: (int index) => provider.homeTabIndex = index,
      children: _pageList,
    );
  }

  void _onVaultItemTap(type, index) {
    Log.d("pick vault item type: $type");
    switch (type) {
      case VaultItemType.login:
        NavigatorUtils.pushResult(
          context,
          RoutersVault.vaultDetailLogin,
          (result) => _doRefresh(_tabLoginsKey, result),
        );
        break;
      case VaultItemType.credit:
        NavigatorUtils.pushResult(
          context,
          RoutersVault.vaultDetailCards,
          (result) => _doRefresh(_tabCardsKey, result),
        );
        break;
      case VaultItemType.note:
        NavigatorUtils.pushResult(
          context,
          RoutersVault.vaultSecureNotes,
          (result) => _doRefresh(_tabNotesKey, result),
        );
        break;
    }
  }

  void _doRefresh(GlobalKey<TabBasePageState> key, dynamic result) {
    if (result["changed"] == true) {
      key.currentState?.provider.fetchData(reset: true);
    }
  }

  bool _onBackPress() {
    if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeEndDrawer();
      return true;
    }
    return false;
  }

  void _scan() {
    NavigatorUtils.pushResult(context, RouterScanner.scanner, (dynamic data) {
      try {
        final params = data['data'];
        SignInByScanner()
            .loginByQrCode(jsonDecode(params))
            .then((value) => NavigatorUtils.push(
                context, RouterUser.signInByScanner,
                arguments: {"data": params}))
            .catchError((err) {
          Toast.showSpec(err.toString());
          Log.d(err.toString());
        });
      } catch (e) {
        Log.d(e.toString());
      }
    });
  }

  void _onActionPerform(HomePageAction action) {
    switch (action) {
      case HomePageAction.setting:
        // _scaffoldKey.currentState?.openEndDrawer();
        NavigatorUtils.push(context, RouterSetting.setting);
        break;
      case HomePageAction.locale:
        _scaffoldKey.currentState?.closeEndDrawer();
        LocaleDialog().show(context);
        break;
      case HomePageAction.theme:
        _scaffoldKey.currentState?.closeEndDrawer();
        ThemeDialog().show(context);
        break;
      case HomePageAction.scan:
        _scan();
        break;
      default:
        Log.d("_onActionPerform: ${action.name}", tag: "HomePageV2");
    }
  }

  @override
  HomeProvider prepareProvider() {
    return HomeProvider();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    provider.repoDB.close();
  }
}
