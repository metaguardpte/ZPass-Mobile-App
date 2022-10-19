extension StringExt on String {
  ///邮箱验证
  bool isEmail() {
    return RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$").hasMatch(this);
  }

  /// 密码
  bool isValidPassword() {
    return RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?).{8,}$").hasMatch(this);
  }
}