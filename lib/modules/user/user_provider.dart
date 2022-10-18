class UserProvider {
  static UserProvider get instance => UserProvider._internal();
  static const String _kUserProviderKey = 'kUserProvider';

  late dynamic _userInfo;
  factory UserProvider() {
    return instance;
  }
  UserProvider._internal() {
    _userInfo = {};
  }

  void updateUser(dynamic raw) {
    _userInfo = raw;
  }
}