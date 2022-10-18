import 'package:flutter/material.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/user/register/register_provider.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/util/string_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/zpass_textfield.dart';

class RegisterSetupPassword extends StatefulWidget {
  const RegisterSetupPassword({Key? key, required this.provider}) : super(key: key);

  final RegisterProvider provider;

  @override
  State<RegisterSetupPassword> createState() => _RegisterSetupPasswordState();
}

class _RegisterSetupPasswordState extends ProviderState<RegisterSetupPassword, RegisterProvider> {

  String _password = "";

  @override
  Widget buildContent(BuildContext context) {
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
                  onTextChange: (value) => provider.password = value,
                  onEditingComplete: () => _checkPasswordIsValid(_password),
                ),
                Gaps.vGap16,
                ZPassTextField(
                  type: TextFieldType.password,
                  title: S.current.registerConfirmPassword,
                  hintText: S.current.registerConfirmPasswordHint,
                  onTextChange: (value) => provider.confirmPassword = value,
                  onEditingComplete: () => _checkPasswordIsValid(provider.confirmPassword),
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

  void _checkPasswordIsValid(String value) {
    bool isValid = StringUtils.isValidPassword(value);
    if (!isValid) {
      Toast.show(S.current.registerPasswordFormatError);
    }
  }

  @override
  RegisterProvider prepareProvider() {
    return widget.provider;
  }
}
