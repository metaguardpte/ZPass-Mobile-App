extension StringExt on String {
  // 邮箱验证
  bool get isEmail => RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$").hasMatch(this);
  // 密码, 大写字母，小写字母，数字，特殊符号，四选三
  bool get isValidPassword => RegExp(r"^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\W_!@#$%^&*`~()-+=]+$)(?![a-z0-9]+$)(?![a-z\W_!@#$%^&*`~()-+=]+$)(?![0-9\W_!@#$%^&*`~()-+=]+$)[a-zA-Z0-9\W_!@#$%^&*`~()-+=]{8,32}$").hasMatch(this);
  // url
  bool get isUrl => RegExp(r"^(?:http|https)://[\w\-_]+(?:\.[\w\-_]+)+[\w\-.,@?^=%&:/~\\+#]*$").hasMatch(this);
}