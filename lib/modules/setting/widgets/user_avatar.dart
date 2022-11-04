import 'package:flutter/material.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/load_image.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, this.url, this.placeholder}) : super(key: key);
  final String? url;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return _buildAvatar(context);
  }

  Widget _buildAvatar(BuildContext context) {
    final avatarUrl = url ?? "";
    final name = placeholder ?? "Z";
    final defaultAvatar = Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(17)
      ),
      child: Text(
        name.toUpperCase().characters.first,
        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
    final avatar = ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: LoadImage(avatarUrl, width: 34, height: 34, holderError: defaultAvatar),
    );
    return avatarUrl.isNotEmpty ? avatar : defaultAvatar;
  }
}
