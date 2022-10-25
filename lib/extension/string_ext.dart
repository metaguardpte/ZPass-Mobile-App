const String passwordRegExpStr = r"^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\W_!@#$%^&*`~()-+=]+$)(?![a-z0-9]+$)(?![a-z\W_!@#$%^&*`~()-+=]+$)(?![0-9\W_!@#$%^&*`~()-+=]+$)[a-zA-Z0-9\W_!@#$%^&*`~()-+=]{8,32}$";
const String emailRegExpStr = r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$";

extension StringExt on String {
  // 邮箱验证
  bool get isEmail => RegExp(emailRegExpStr).hasMatch(this);
  // 密码, 大写字母，小写字母，数字，特殊符号，四选三
  bool get isValidPassword => RegExp(passwordRegExpStr).hasMatch(this);
  // url
  bool get isUrl => RegExp(r"^(?:http|https)://[\w\-_]+(?:\.[\w\-_]+)+[\w\-.,@?^=%&:/~\\+#]*$").hasMatch(this);
}
