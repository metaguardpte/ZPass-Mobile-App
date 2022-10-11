import 'package:zpass/base/base_provider.dart';

class HomeProvider extends BaseProvider {
  HomeProvider._internal();
  factory HomeProvider() => _instance;
  static final HomeProvider _instance = HomeProvider._internal();

  int _homeTabIndex = 0;
  int get homeTabIndex => _homeTabIndex;
  set homeTabIndex(int currentIndex) {
    _homeTabIndex = currentIndex;
    notifyListeners();
  }
}