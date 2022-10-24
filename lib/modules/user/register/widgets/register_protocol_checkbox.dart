import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zpass/base/app_config.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpass/util/theme_utils.dart';

class RegisterProtocolCheckbox extends StatefulWidget {
  const RegisterProtocolCheckbox({Key? key, this.onChange}) : super(key: key);

  final FunctionCallback<bool>? onChange;

  @override
  State<RegisterProtocolCheckbox> createState() => _RegisterProtocolCheckboxState();
}

class _RegisterProtocolCheckboxState extends State<RegisterProtocolCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCheckbox(),
          Flexible(child: _buildProtocolText()),
        ],
      ),
    );
  }
  
  Widget _buildCheckbox() {
    return Transform.scale(
      scale: 0.75,
      child: Checkbox(
          value: _isChecked,
          visualDensity: const VisualDensity(horizontal: -2, vertical: -4),
          activeColor: context.primaryColor,
          side: const BorderSide(color: Color(0xFF4E5E75), width: 0.5),
          onChanged: (bool? value) {
            setState(() {
              _isChecked = value!;
            });
            if (widget.onChange != null) {
              widget.onChange?.call(value!);
            }
          },
      ),
    );
  }

  Widget _buildProtocolText() {
    return EasyRichText(
      "${S.current.userServiceAgreement} ${S.current.registerProtocolAnd} ${S.current.privacyNotice}",
      defaultStyle: const TextStyle(fontSize: 14, color: Color(0xFF0D2249)),
      patternList: [
        EasyRichTextPattern(
          targetString: S.current.userServiceAgreement,
          style: TextStyle(color: context.primaryColor, fontSize: 14),
          recognizer: TapGestureRecognizer()..onTap = () async {
            _openUrl(AppConfig.userAgreementUrl);
          },
        ),
        EasyRichTextPattern(
          targetString: S.current.privacyNotice,
          style: TextStyle(color: context.primaryColor, fontSize: 14),
          recognizer: TapGestureRecognizer()..onTap = () async {
            _openUrl(AppConfig.privacyNoticeUrl);
          },
        ),
      ],
    );
  }

  _openUrl(String url) async {
    final uri = Uri.parse(url);
    bool isCanLaunch = await canLaunchUrl(uri);
    if(isCanLaunch) {
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    }
  }
}
