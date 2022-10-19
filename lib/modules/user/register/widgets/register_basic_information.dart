import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/user/register/register_provider.dart';
import 'package:zpass/modules/user/register/view/register_page.dart';
import 'package:zpass/modules/user/register/widgets/register_email_code.dart';
import 'package:zpass/modules/user/register/widgets/register_selection_dialog.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/modules/user/register/widgets/zpass_register_textfield.dart';
import 'package:zpass/extension/string_ext.dart';


class RegisterBasicInformation extends StatefulWidget {
  const RegisterBasicInformation({
    Key? key,
    required this.provider,
    this.type = RegisterType.personal,
  }) : super(key: key);

  final RegisterType? type;
  final RegisterProvider provider;

  @override
  _RegisterBasicInformationState createState() => _RegisterBasicInformationState();
}

class _RegisterBasicInformationState extends ProviderState<RegisterBasicInformation, RegisterProvider> {
  final List<String> _planTypes = [S.current.registerPlanTypePilot];
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
                  Selector<RegisterProvider, int>(
                      builder: (_, index, __) {
                        return ZPassTextField(
                          title: S.current.registerPlanType,
                          type: TextFieldType.selection,
                          selectionText: _planTypes[provider.planTypeIndex],
                          hintText: S.current.registerPlanTypeHint,
                          onSelectionTap: _onPlanTypeTap,
                        );
                      },
                      selector: (_, provider) => provider.planTypeIndex,
                  ),
                  Gaps.vGap16,
                  /// email
                  Selector<RegisterProvider, Tuple2<bool, bool>>(
                    builder: (_, tuple, __) {
                      final loading = tuple.item1;
                      final visibleCodeField = tuple.item2;
                      return ZPassTextField(
                        title: widget.type == RegisterType.business ? S.current.businessEmail : S.current.email,
                        hintText:widget.type == RegisterType.business ? S.current.businessEmailHint : S.current.emailHint,
                        suffixBtnTitle: visibleCodeField ? S.current.resendCode : null,
                        type: TextFieldType.email,
                        textInputType: TextInputType.emailAddress,
                        loading: loading,
                        onSendCodeTap: _onSendCodeTap,
                        onTextChange: (value) => provider.email = value,
                      );
                    },
                    selector: (_, provider) => Tuple2(provider.emailCodeLoading, provider.visibleEmailVerifyCode),
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
              S.current.enterCode,
              style: const TextStyle(
                  color: Color(0xFF16181A), fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          RegisterEmailCode(onResult: (value) => provider.emailVerifyCode = value),
        ],
      ),
    );
  }

  Widget _buildEmailCodeTips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: const Icon(ZPassIcons.icWarnCircle, size: 16, color: Color(0xFF4954FF),),
          ),
          Gaps.hGap5,
          Expanded(
            child: Selector<RegisterProvider, String>(
              builder: (_, email, __) {
                return EasyRichText(
                  S.current.registerEmailCodeTips(email),
                  defaultStyle: const TextStyle(color: Color(0xFF16181A), fontSize: 14, height: 1.5),
                  patternList: [
                    EasyRichTextPattern(
                      targetString: email,
                      style: const TextStyle(
                        color: Color(0xFF16181A),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    )
                  ],
                );
              },
              selector: (_, provider) => provider.email,
            ),
          ),
        ],
      ),
    );
  }

  _onPlanTypeTap() {
    RegisterSelectionDialog(
      title: S.current.registerPlanTypeHint,
      data: _planTypes,
      onSelectedTap: (index) {
        provider.planTypeIndex = index;
      },
    ).show(context);
  }

  _onSendCodeTap() async {
    provider.email = provider.email.trim();
    if (provider.email.isEmpty) {
      Toast.show(S.current.emailHint);
      return;
    }
    if (!provider.email.isEmail) {
      Toast.show(S.current.emailInvalid);
      return;
    }
    final errorId = await provider.doGetEmailVerifyCode();
    if ((errorId ?? "").isNotEmpty) {
      Toast.show(errorId);
    }
  }

  @override
  RegisterProvider prepareProvider() {
    return widget.provider;
  }
}
