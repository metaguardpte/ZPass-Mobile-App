const regWithSchema = r"/https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)?/gi";
const regWithoutSchema = r"/[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)?/gi";

extension StringExt on String {
  // 邮箱验证
  bool get isEmail => RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$").hasMatch(this);
  // 密码
  bool get isValidPassword => RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?).{8,}$").hasMatch(this);
  // url with http
  bool get isUrlWithHttp => RegExp(regWithSchema).hasMatch(this);
  // url without http
  bool get isUrlWithoutHttp => RegExp(regWithoutSchema).hasMatch(this);
}