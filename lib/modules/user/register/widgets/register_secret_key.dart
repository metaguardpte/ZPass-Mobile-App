import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/widgets/load_image.dart';

class RegisterSecretKey extends StatefulWidget {
  const RegisterSecretKey({Key? key}) : super(key: key);

  @override
  State<RegisterSecretKey> createState() => _RegisterSecretKeyState();
}

class _RegisterSecretKeyState extends State<RegisterSecretKey> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        children: [
          _buildMessage(),
          _buildKey(),
          Gaps.vGap10,
          _buildActionItem(S.current.registerSecretKeyCopy, "ic_copy", _onCopySecretKeyTap),
          Gaps.vGap15,
          _buildActionItem(S.current.registerSecretKeySave, "ic_download", _onSaveSecretKeyTap),
        ],
      ),
    );
  }
  
  Widget _buildMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.registerSecretKeyTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF16181A),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            S.current.registerSecretKeyMessage,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF16181A),
              height: 1.3
            ),
          ),
        )
      ],
    );
  }

  Widget _buildKey() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xFFF6F6F6),
      ),
      child: const Text(
        "V1-00A5-6BFF-D19A-DD46-956E-A1E5-2482-7E9E",
        style: TextStyle(
            color: Color(0xFFFF7019), fontSize: 16, fontWeight: FontWeight.w500,
          height: 1.6
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionItem(String title, String icon, GestureTapCallback event) {
    return GestureDetector(
      onTap: event,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4954FF)),
          borderRadius: BorderRadius.circular(7.5)
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Color(0xFF16181A),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: LoadAssetImage(icon, width: 16, height: 16,),
            )
          ],
        ),
      ),
    );
  }

  _onCopySecretKeyTap() {
    print("copy xxxxx");
  }

  _onSaveSecretKeyTap() {
    print("save xxxxx");
  }
}
