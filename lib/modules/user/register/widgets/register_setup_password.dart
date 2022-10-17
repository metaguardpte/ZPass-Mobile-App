import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/widgets/zpass_textfield.dart';

class RegisterSetupPassword extends StatefulWidget {
  const RegisterSetupPassword({Key? key}) : super(key: key);

  @override
  State<RegisterSetupPassword> createState() => _RegisterSetupPasswordState();
}

class _RegisterSetupPasswordState extends State<RegisterSetupPassword> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.white,
            child: Column(
              children: [
                ZPassTextField(
                  type: TextFieldType.password,
                  title: S.current.registerMasterPassword,
                  hintText: S.current.registerMasterPasswordHint,
                ),
                Gaps.vGap16,
                ZPassTextField(
                  type: TextFieldType.password,
                  title: S.current.registerConfirmPassword,
                  hintText: S.current.registerConfirmPasswordHint,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            child: Text(
              S.current.registerPasswordTips,
              style: const TextStyle(color: Color(0xFF16181A), fontSize: 12, height: 1.5),
            ),
          )
        ],
      ),
    );
  }
}
