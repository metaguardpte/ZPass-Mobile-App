import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/provider/home_provider.dart';
import 'package:zpass/modules/home/widgets/home_app_bar_builder.dart';
import 'package:zpass/modules/home/widgets/home_bottom_bar_builder.dart';
import 'package:zpass/modules/home/tabs/tab_cards.dart';
import 'package:zpass/modules/home/tabs/tab_identities.dart';
import 'package:zpass/modules/home/tabs/tab_logins.dart';
import 'package:zpass/modules/home/tabs/tab_notes.dart';
import 'package:zpass/modules/home/widgets/home_drawer_builder.dart';
import 'package:zpass/modules/setting/widgets/locale_dialog.dart';
import 'package:zpass/modules/setting/widgets/theme_dialog.dart';
import 'package:zpass/modules/user/router_user.dart';
import 'package:zpass/res/zpass_fonts_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/theme_utils.dart';
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 显示状态栏和导航栏
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    WidgetsBinding.instance.addObserver(this);
    _items = <TabItem>[
      TabItem(icon: ZPassFonts.logins, activeIcon: ZPassFonts.loginsActive, title: S.current.tabLogins),
      TabItem(icon: ZPassFonts.secureNotes, activeIcon: ZPassFonts.secureNotesActive, title: S.current.tabSecureNotes),
      const TabItem(icon: Icons.add_rounded, title: "Fake"),
      TabItem(icon: ZPassFonts.creditCards, activeIcon: ZPassFonts.creditCardsActive, title: S.current.tabCreditCards),
      TabItem(icon: ZPassFonts.identities, activeIcon: ZPassFonts.identitiesActive, title: S.current.tabIdentities),
    ];
    _pageList = [
      const TabLoginsPage(),
      const TabNotesPage(),
      Container(),
      const TabCardsPage(),
      const TabIdentitiesPage(),
    ];
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Log.d("APP State: ${state.toString()}", tag: "AppLifecycleState");
    if (state == AppLifecycleState.resumed) {
    } else {}
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
          NavigatorUtils.push(context, RouterUser.login);
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

  bool _onBackPress() {
    if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeEndDrawer();
      return true;
    }
    return false;
  }

  void _onActionPerform(HomePageAction action) {
    switch (action) {
      case HomePageAction.setting:
        _scaffoldKey.currentState?.openEndDrawer();
        break;
      case HomePageAction.locale:
        _scaffoldKey.currentState?.closeEndDrawer();
        LocaleDialog().show(context);
        break;
      case HomePageAction.theme:
        _scaffoldKey.currentState?.closeEndDrawer();
        ThemeDialog().show(context);
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
  }
}
