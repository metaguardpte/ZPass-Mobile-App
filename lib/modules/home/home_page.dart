import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/provider/home_provider.dart';
import 'package:zpass/modules/home/tabs/tab_cards.dart';
import 'package:zpass/modules/home/tabs/tab_logins.dart';
import 'package:zpass/modules/home/tabs/tab_notes.dart';
import 'package:zpass/res/colors.dart';
import 'package:zpass/res/dimens.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/double_tap_back_exit_app.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ProviderState<HomePage, HomeProvider>
    with WidgetsBindingObserver {
  late List<Widget> _pageList;
  late final PageController _pageController = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 显示状态栏和导航栏
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    WidgetsBinding.instance.addObserver(this);
    _initData();
    super.initState();
  }

  void _initData() {
    _pageList = [
      const TabLoginsPage(),
      const TabNotesPage(),
      const TabCardsPage(),
    ];
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
        bottomNavigationBar: Consumer<HomeProvider>(builder: (_, provider, __) {
          return _buildAppNavigationBar();
        }),
      ),
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

  Widget _buildAppNavigationBar() {
    final bool isDark = context.isDark;
    return BottomNavigationBar(
      backgroundColor: context.backgroundColor,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: S.current.tabLogins,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.business),
          label: S.current.tabSecureNotes,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.school),
          label: S.current.tabCreditCards,
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: provider.homeTabIndex,
      elevation: 5.0,
      iconSize: 21.0,
      selectedFontSize: Dimens.font_sp10,
      unselectedFontSize: Dimens.font_sp10,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: isDark
          ? Colours.dark_unselected_item_color
          : Colours.unselected_item_color,
      onTap: (index) => _pageController.jumpToPage(index),
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
