import 'package:zpass/base/base_provider.dart';
import 'package:zpass/modules/home/repo/repo_db.dart';

class HomeProvider extends BaseProvider {
  factory HomeProvider() => _instance;
  static final HomeProvider _instance = HomeProvider._internal();

  late final RepoDB _repoDB;
  RepoDB get repoDB => _repoDB;

  HomeProvider._internal() {
    _repoDB = RepoDB();
  }

  int _homeTabIndex = 0;
  int get homeTabIndex => _homeTabIndex;
  set homeTabIndex(int currentIndex) {
    _homeTabIndex = currentIndex;
    notifyListeners();
  }
}