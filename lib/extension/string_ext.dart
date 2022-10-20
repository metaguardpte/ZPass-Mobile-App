extension StringExt on String {
  // 邮箱验证
  bool get isEmail => RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$").hasMatch(this);
  // 密码
  bool get isValidPassword => RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?).{8,}$").hasMatch(this);
  // url
  bool get isUrl => RegExp(r"^(?:http|https)://[\w\-_]+(?:\.[\w\-_]+)+[\w\-.,@?^=%&:/~\\+#]*$").hasMatch(this);
}