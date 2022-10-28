import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpass/extension/int_ext.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/vault/login/login_detail_helper.dart';
import 'package:zpass/modules/vault/login/login_detail_provider.dart';
import 'package:zpass/modules/vault/model/vault_item_login_content.dart';
import 'package:zpass/modules/vault/vault_detail_base_state.dart';
import 'package:zpass/res/resources.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/zpass_card.dart';
import 'package:zpass/widgets/zpass_edittext.dart';

class LoginDetailPage extends StatefulWidget {
  final VaultItemEntity? data;

  const LoginDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  State<LoginDetailPage> createState() => _LoginDetailPageState();
}

class _LoginDetailPageState
    extends BaseVaultPageState<LoginDetailPage, LoginDetailProvider> {
  static const double itemHeight = 30, space = 12;

  final _formKey = GlobalKey<FormState>();
  final _loginNameKey = GlobalKey<ZPassEditTextState>();
  final _loginPwdKey = GlobalKey<ZPassEditTextState>();
  final _loginNoteKey = GlobalKey<ZPassEditTextState>();

  @override
  void initState() {
    super.initState();
    provider.analyticsData(widget.data);
  }

  @override
  String get title => S.current.tabLogins;

  @override
  LoginDetailProvider prepareProvider() {
    return LoginDetailProvider();
  }

  @override
  Widget buildBody(bool editing) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Selector<LoginDetailProvider, VaultItemLoginContent?>(
            builder: (_, content, __) {
              Log.d(
                  "user: ${content?.loginUser}, password: ${content?.loginPassword}");
              if (content != null) {
                _loginNameKey.currentState?.fillText(content.loginUser);
                _loginPwdKey.currentState?.fillText(content.loginPassword);
                if (content.note != null) {
                  _loginNoteKey.currentState?.fillText(content.note!);
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRequiredSection(editing, content),
                  Gaps.vGap16,
                  Visibility(
                      visible: editing ||
                          content?.note != null ||
                          provider.entity?.tags != null &&
                              provider.entity!.tags!.isNotEmpty,
                      child: buildOptionalSection(editing, content)),
                  Gaps.vGap12,
                  buildTips(),
                ],
              );
            },
            selector: (_, provider) => provider.content),
      ),
    );
  }

  Widget buildRequiredSection(bool editing, VaultItemLoginContent? content) {
    return ZPassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildHint(context, S.current.vaultTitle, star: editing),
              Gaps.vGap8,
              ZPassEditText(
                initialText: provider.entity?.name,
                hintText: emptyHint,
                prefix: buildLoginFav(context, provider.entity),
                enableClear: editing,
                enableCopy: !editing,
              ),
              Gaps.vGap16,
              buildHint(context, S.current.vaultLoginName, star: editing),
              Gaps.vGap8,
              ZPassEditText(
                key: _loginNameKey,
                initialText: content?.loginUser,
                hintText: emptyHint,
                enablePrefix: false,
                enableClear: editing,
                enableCopy: !editing,
              ),
              Gaps.vGap16,
              buildHint(context, S.current.vaultLoginPwd, star: editing),
              Gaps.vGap8,
              ZPassEditText(
                key: _loginPwdKey,
                initialText: content?.loginPassword,
                hintText: emptyHint,
                obscureText: !editing,
                enablePrefix: false,
                enableClear: editing,
                enableCopy: !editing,
              ),
              Gaps.vGap16,
              buildHint(context, S.current.vaultLoginURL, star: editing),
              Gaps.vGap8,
              ZPassEditText(
                initialText: provider.targetUrl,
                hintText: emptyHint,
                enablePrefix: false,
                enableClear: editing,
                enableCopy: !editing,
              ),
            ],
          )),
    );
  }

  Widget buildOptionalSection(bool editing, VaultItemLoginContent? content) {
    return ZPassCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHint(context, S.current.vaultNote, star: false),
            Gaps.vGap8,
            ZPassEditText(
              key: _loginNoteKey,
              initialText: content?.note,
              hintText: emptyHint,
              enablePrefix: false,
              enableClear: editing,
              enableCopy: !editing,
              maxLines: 3,
              height: 70,
              maxLength: 100,
            ),
            Gaps.vGap16,
            buildHint(context, S.current.vaultTag, star: false),
            Gaps.vGap12,
            buildTags(editing),
          ],
        ));
  }

  Widget buildTags(bool editing) {
    final createNew = buildTagItem(
        text: "Add Tag",
        prefix: Icon(
          Icons.add,
          size: 15,
          color: context.primaryColor,
        ),
        color: context.primaryColor,
        bgColor: const Color(0XFFF1F2FF));
    if (provider.entity?.tags == null ||
        provider.entity?.tags?.isEmpty == true) {
      return createNew;
    } else {
      final items = <Widget>[];
      items.addAll(List.generate(
          provider.entity!.tags!.length,
          (index) => buildTagItem(
              text: provider.entity!.tags!.elementAt(index),
              editing: editing)));
      if (!editing) items.add(createNew);
      return SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: space,
          runSpacing: space,
          children: items,
        ),
      );
    }
  }

  Widget buildTagItem(
      {required String text,
      bool editing = false,
      Widget? prefix,
      Color? color,
      Color? bgColor}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor ?? context.secondaryBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
          height: itemHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            prefix ?? Gaps.empty,
            Text(
              text,
              style: TextStyles.textSize14.copyWith(color: color ?? context.textColor1),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ])),
    );
  }

  Widget buildTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: provider.entity?.updateTime != null,
            child: Row(
              children: [
                Icon(Icons.access_time, size: 15, color: context.textColor3),
                Container(
                  padding: const EdgeInsets.only(left: 3, right: 18),
                  child: Text(
                    "Update time: ${provider.entity?.updateTime.formatDateTime()}",
                    style: TextStyles.textSize12
                        .copyWith(color: context.textColor3),
                  ),
                ),
              ],
            )),
        Visibility(
            visible: provider.entity?.createTime != null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text(
                "Create time: ${provider.entity?.createTime.formatDateTime()}",
                style:
                    TextStyles.textSize12.copyWith(color: context.textColor3),
              ),
            )),
      ],
    );
  }
}
