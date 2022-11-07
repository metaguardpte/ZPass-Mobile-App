const String passwordRegExpStr = r"^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\W_!@#$%^&*`~()-+=]+$)(?![a-z0-9]+$)(?![a-z\W_!@#$%^&*`~()-+=]+$)(?![0-9\W_!@#$%^&*`~()-+=]+$)[a-zA-Z0-9\W_!@#$%^&*`~()-+=]{8,32}$";
const String emailRegExpStr = r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$";

extension StringExt on String {
  // email
  bool get isEmail => RegExp(emailRegExpStr).hasMatch(this);
  // password
  bool get isValidPassword => RegExp(passwordRegExpStr).hasMatch(this);
  // url
  bool get isUrl => RegExp(r"^(?:http|https)://[\w\-_]+(?:\.[\w\-_]+)+[\w\-.,@?^=%&:/~\\+#]*$").hasMatch(this);
}
