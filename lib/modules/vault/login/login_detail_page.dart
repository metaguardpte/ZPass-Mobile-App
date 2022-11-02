import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpass/extension/int_ext.dart';
import 'package:zpass/extension/string_ext.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/vault/login/login_detail_helper.dart';
import 'package:zpass/modules/vault/login/login_detail_provider.dart';
import 'package:zpass/modules/vault/model/vault_item_login_content.dart';
import 'package:zpass/modules/vault/vault_detail_base_state.dart';
import 'package:zpass/modules/vault/vault_detail_tags.dart';
import 'package:zpass/res/resources.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/zpass_card.dart';
import 'package:zpass/widgets/zpass_form_edittext.dart';

class LoginDetailPage extends StatefulWidget {
  final VaultItemEntity? data;

  const LoginDetailPage({Key? key, this.data})
      : super(key: key);

  @override
  State<LoginDetailPage> createState() => _LoginDetailPageState();
}

class _LoginDetailPageState
    extends BaseVaultPageState<LoginDetailPage, LoginDetailProvider> {

  final _formKey = GlobalKey<FormState>();
  final _titleKey = GlobalKey<ZPassFormEditTextState>();
  final _nameKey = GlobalKey<ZPassFormEditTextState>();
  final _pwdKey = GlobalKey<ZPassFormEditTextState>();
  final _urlKey = GlobalKey<ZPassFormEditTextState>();
  final _noteKey = GlobalKey<ZPassFormEditTextState>();
  final _tagKey = GlobalKey<VaultDetailTagsState>();

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
                _nameKey.currentState?.fillText(content.loginUser);
                _pwdKey.currentState?.fillText(content.loginPassword);
                if (content.note != null) {
                  _noteKey.currentState?.fillText(content.note!);
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
                              provider.tags.isNotEmpty,
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
              ZPassFormEditText(
                key: _titleKey,
                initialText: provider.entity?.name,
                hintText: emptyHint,
                prefix: buildLoginFav(context, provider.entity),
                filled: true,
                enable: editing,
                enableClear: editing,
                enableCopy: !editing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter item name";
                  }
                  return null;
                },
              ),
              Gaps.vGap16,
              buildHint(context, S.current.vaultLoginName, star: editing),
              Gaps.vGap8,
              ZPassFormEditText(
                key: _nameKey,
                initialText: content?.loginUser,
                hintText: emptyHint,
                filled: true,
                enable: editing,
                enablePrefix: false,
                enableClear: editing,
                enableCopy: !editing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter login name";
                  }
                  return null;
                },
              ),
              Gaps.vGap16,
              buildHint(context, S.current.vaultLoginPwd, star: editing),
              Gaps.vGap8,
              ZPassFormEditText(
                key: _pwdKey,
                initialText: content?.loginPassword,
                hintText: emptyHint,
                obscureText: !editing,
                filled: true,
                enable: editing,
                enablePrefix: false,
                enableClear: editing,
                enableCopy: !editing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter login password";
                  }
                  return null;
                },
              ),
              Gaps.vGap16,
              buildHint(context, S.current.vaultLoginURL, star: editing),
              Gaps.vGap8,
              ZPassFormEditText(
                key: _urlKey,
                initialText: provider.targetUrl,
                hintText: emptyHint,
                filled: true,
                enable: editing,
                enablePrefix: false,
                enableClear: editing,
                enableCopy: !editing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter login page url";
                  }
                  if (!(value as String).isUrl) {
                    return "Please enter valid url";
                  }
                  return null;
                },
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
            ZPassFormEditText(
              key: _noteKey,
              initialText: content?.note,
              hintText: emptyHint,
              filled: true,
              enable: editing,
              enablePrefix: false,
              enableClear: editing,
              enableCopy: !editing,
              maxLines: 3,
              height: 70,
              maxLength: 100,
            ),
            _buildTagContainer(editing),
          ],
        ));
  }

  Widget _buildTagContainer(bool editing) {
    return VaultDetailTags(
      key: _tagKey,
      tags: provider.tags,
      editing: editing,
      onTagChange: (value) => provider.tags = value,
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

  @override
  void onEditPress() {
    if (provider.editing) {
      //try to save
      if (!_formKey.currentState!.validate()) {
        return;
      }
      provider.editing = false;

      provider.updateData(
        title: _titleKey.currentState!.text,
        name: _nameKey.currentState!.text,
        passwd: _pwdKey.currentState!.text,
        url: _urlKey.currentState!.text,
        note: _noteKey.currentState!.text
      ).then((succeed) {
        if (succeed) {
          Toast.show("Item saved");
          NavigatorUtils.goBackWithParams(context, {"changed": true});
        } else {
          Toast.showError("Failed to save item");
        }
      } ).catchError((e) {
        Toast.showError("Failed to save item: $e");
      });
    } else {
      provider.editing = true;
    }
  }

  @override
  void onCancelPress() {
    provider.tags = [...widget.data?.tags ?? []];
    _tagKey.currentState?.resetTag();
  }
}
