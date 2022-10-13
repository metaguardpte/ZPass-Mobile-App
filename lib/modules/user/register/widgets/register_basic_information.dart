import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/user/register/register_provider.dart';
import 'package:zpass/modules/user/register/view/register_page.dart';
import 'package:zpass/modules/user/register/widgets/register_email_code.dart';
import 'package:zpass/modules/user/register/widgets/register_selection_dialog.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/widgets/zpass_textfield.dart';


class RegisterBasicInformation extends StatefulWidget {
  const RegisterBasicInformation({
    Key? key,
    required this.provider,
    this.type = RegisterType.personal,
    this.visibleCode = false,
  }) : super(key: key);

  final RegisterType? type;
  final bool? visibleCode;
  final RegisterProvider provider;

  @override
  _RegisterBasicInformationState createState() => _RegisterBasicInformationState();
}

class _RegisterBasicInformationState extends ProviderState<RegisterBasicInformation, RegisterProvider> {
  String _planType = "";
  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// plan type
                  ZPassTextField(
                    title: S.current.registerPlanType,
                    type: TextFieldType.selection,
                    selectionText: _planType,
                    hintText: S.current.registerPlanTypeHint,
                    onSelectionTap: _onPlanTypeTap,
                  ),
                  Gaps.vGap16,
                  /// email
                  Selector<RegisterProvider, bool>(
                    builder: (_, loading, __) {
                      return ZPassTextField(
                        title: widget.type == RegisterType.business ? S.current.businessEmail : S.current.email,
                        hintText:widget.type == RegisterType.business ? S.current.businessEmailHint : S.current.emailHint,
                        type: TextFieldType.email,
                        textFieldTips: S.current.registerEmailTips,
                        loading: loading,
                        onSendCodeTap: _onSendCodeTap,
                      );
                    },
                    selector: (_, provider) => provider.emailCodeLoading,
                  ),
                  Gaps.vGap10,
                  /// domain name
                  Visibility(
                    visible: widget.type == RegisterType.business,
                    child: ZPassTextField(
                      title: S.current.domainName,
                      hintText: S.current.domainNameHint,
                      textFieldTips: S.current.domainNameTips,
                    ),
                  ),
                  /// email code
                  Selector<RegisterProvider, bool>(
                    builder: (_, visible, __) {
                      return Visibility(
                        visible: visible,
                        child: _buildEmailCode(),
                      );
                    },
                    selector: (_, provider) => provider.visibleEmailVerifyCode,
                  ),
                ],
              ),
            ),
          ),
          /// email code tips
          Selector<RegisterProvider, bool>(
            builder: (_, visible, __) {
              return Visibility(
                visible: visible,
                child: _buildEmailCodeTips(),
              );
            },
            selector: (_, provider) => provider.visibleEmailVerifyCode,
          )
        ],
      ),
    );
  }

  Widget _buildEmailCode() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              S.current.enterCode ?? "",
              style: const TextStyle(
                  color: Color(0xFF16181A), fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          RegisterEmailCode(),
        ],
      ),
    );
  }

  Widget _buildEmailCodeTips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13.5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("We sent a 6-digit verification code to", style: TextStyle(color: Color(0xFF16181A), fontSize: 14, height: 1.3),),
                Text("「447162100@qq.com」", style: TextStyle(color: Color(0xFF16181A), fontSize: 14, fontWeight: FontWeight.w500, height: 1.5),),
                Text(
                  "Did not receive the code? Please carefully check your  \"Junk Emails\" and blocked Emails.",
                  style: TextStyle(color: Color(0xFF16181A), fontSize: 14,height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onPlanTypeTap() {
    RegisterSelectionDialog(
      title: S.current.registerPlanTypeHint,
      data: ["Pilot"],
      onSelectedTap: (index) {
        print("$index");
        setState(() {
          _planType = ["Pilot"][index];
        });
      },
    ).show(context);
  }

  _onSendCodeTap() {
    provider.emailCodeLoading = true;
    Future.delayed(const Duration(milliseconds: 5000), () {
      provider.emailCodeLoading = false;
      provider.visibleEmailVerifyCode = true;
    });
  }

  @override
  RegisterProvider prepareProvider() {
    return widget.provider;
  }
}
