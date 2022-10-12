import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/provider/home_provider.dart';
import 'package:zpass/modules/home/widgets/home_bottom_bar_builder.dart';
import 'package:zpass/modules/home/widgets/home_bottom_bar_style.dart';
import 'package:zpass/modules/tab_home/tab_home.dart';
import 'package:zpass/modules/tab_me/tab_me.dart';
import 'package:zpass/modules/tab_signal/tab_signal.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/double_tap_back_exit_app.dart';

class HomePageV2 extends StatefulWidget {
  const HomePageV2({Key? key}) : super(key: key);

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends ProviderState<HomePageV2, HomeProvider> with WidgetsBindingObserver {
  late final List<TabItem> _items;
  late final List<Widget> _pageList;
  late final PageController _pageController = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 显示状态栏和导航栏
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    WidgetsBinding.instance.addObserver(this);
    _items = <TabItem>[
      TabItem(icon: Icons.home_outlined, activeIcon: Icons.home, title: S.current.tabHome),
      TabItem(icon: Icons.close, activeIcon: Icons.close, title: S.current.tabSignal),
      TabItem(icon: Icons.school_outlined, activeIcon: Icons.school, title: S.current.tabMe),
    ];
    _pageList = [
      const TabHomePage(),
      const TabSignalPage(),
      const TabMePage(),
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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.backgroundColor,
        body: _buildPageView(),
        bottomNavigationBar: _buildAppNavigationBar(),
      ),
    );
  }

  Widget _buildAppNavigationBar() {
    return ConvexAppBar.builder(
      itemBuilder: HomeBottomBarBuilder(_items, context.backgroundColor),
      count: _items.length,
      backgroundColor: context.backgroundColor,
      onTapNotify: (i) {
        var intercept = i == 1;
        if (intercept) {
          Navigator.pushNamed(context, '/fab');
        }
        return !intercept;
      },
      onTap: (int index) => _pageController.jumpToPage(index),
      shadowColor: const Color(0x508792a4),
      // height: 55,
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
