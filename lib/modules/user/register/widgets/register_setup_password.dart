import 'package:flutter/material.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/extension/string_ext.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/user/register/register_provider.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/modules/user/register/widgets/zpass_register_textfield.dart';

class RegisterSetupPassword extends StatefulWidget {
  const RegisterSetupPassword({Key? key, required this.provider}) : super(key: key);

  final RegisterProvider provider;

  @override
  State<RegisterSetupPassword> createState() => _RegisterSetupPasswordState();
}

class _RegisterSetupPasswordState extends ProviderState<RegisterSetupPassword, RegisterProvider> {

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
                  text: provider.password,
                  autoFocus: true,
                  type: TextFieldType.password,
                  title: S.current.registerMasterPassword,
                  hintText: S.current.registerMasterPasswordHint,
                  onTextChange: (value) => provider.password = value,
                  onUnFocus: () => _checkPasswordIsValid(provider.password),
                ),
                Gaps.vGap16,
                ZPassTextField(
                  text: provider.confirmPassword,
                  type: TextFieldType.password,
                  title: S.current.registerConfirmPassword,
                  hintText: S.current.registerConfirmPasswordHint,
                  onTextChange: (value) => provider.confirmPassword = value,
                  onUnFocus: () => _checkPasswordIsValid(provider.confirmPassword),
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
    if (value.isEmpty) return;
    if (!value.isValidPassword) {
      Toast.show(S.current.registerPasswordFormatError);
    }
  }

  @override
  RegisterProvider prepareProvider() {
    return widget.provider;
  }
}
