import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/vault/login/login_detail_helper.dart';
import 'package:zpass/modules/vault/model/vault_item_secure_note_content.dart';
import 'package:zpass/modules/vault/secure_notes/secure_notes_icon.dart';
import 'package:zpass/modules/vault/secure_notes/secure_notes_provider.dart';
import 'package:zpass/modules/vault/vault_detail_base_state.dart';
import 'package:zpass/modules/vault/vault_detail_tags.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/styles.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/zpass_card.dart';
import 'package:zpass/widgets/zpass_form_edittext.dart';
import 'package:zpass/extension/int_ext.dart';

class SecureNotesPage extends StatefulWidget {
  final VaultItemEntity? data;

  const SecureNotesPage({Key? key, this.data}) : super(key: key);

  @override
  State<SecureNotesPage> createState() => _SecureNotesPageState();
}

class _SecureNotesPageState
    extends BaseVaultPageState<SecureNotesPage, SecureNotesProvider> {
  final _formKey = GlobalKey<FormState>();
  final _secureTitle = GlobalKey<ZPassFormEditTextState>();
  final _secureNote = GlobalKey<ZPassFormEditTextState>();
  final _tagKey = GlobalKey<VaultDetailTagsState>();

  @override
  void initState() {
    super.initState();
    provider.analyticsData(widget.data);
  }

  @override
  Widget buildBody(bool editing) {
    return SingleChildScrollView(
        child: Selector<SecureNotesProvider, VaultItemSecureNoteContent?>(
            builder: (_, content, __) {
              if (content != null) {
                _secureNote.currentState?.fillText(content.note);
                _secureTitle.currentState?.fillText(content.title);
              }
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 16, right: 16, top: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 18, bottom: 18),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(11))),
                        child: Column(
                          children: [
                            buildHint(context, S.current.title, star: editing),
                            Gaps.vGap8,
                            ZPassFormEditText(
                              key: _secureTitle,
                              initialText: provider.content?.title,
                              hintText: emptyHint,
                              prefix: buildSecureNotesIcon(
                                  context, provider.entity),
                              filled: !editing,
                              readOnly: !editing,
                              borderColor:
                                  const Color.fromRGBO(235, 235, 238, 1),
                              enableClear: editing,
                              enableCopy: !editing,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter item title";
                                }
                                return null;
                              },
                            ),
                            Gaps.vGap16,
                            buildHint(context, S.current.note),
                            Gaps.vGap8,
                            ZPassFormEditText(
                              initialText: provider.content?.note,
                              key: _secureNote,
                              hintText: emptyHint,
                              filled: !editing,
                              readOnly: !editing,
                              enablePrefix: false,
                              enableClear: editing,
                              enableCopy: !editing,
                              maxLines: 5,
                              borderColor:
                                  const Color.fromRGBO(235, 235, 238, 1),
                              height: 70,
                              maxLength: 100,
                            ),
                          ],
                        ),
                      ),
                      Gaps.vGap16,
                      _buildTagContainer(editing),
                      Gaps.vGap16,
                      _buildTips(),
                    ],
                  ),
                ),
              );
            },
            selector: (_, provider) => provider.content));
  }

  Widget _buildTagContainer(bool editing) {
    return !editing && provider.tags.isEmpty
        ? Gaps.empty
        : ZPassCard(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
            child: VaultDetailTags(
              key: _tagKey,
              tags: provider.tags,
              editing: editing,
              onTagChange: (value) => provider.tags = value,
            ),
          );
  }

  Widget _buildTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<SecureNotesProvider, int?>(
          builder: (_, updateTime, __) {
            return Visibility(
              visible: updateTime != null,
              child: Row(
                children: [
                  Icon(Icons.access_time,
                      size: 15, color: context.textColor3),
                  Container(
                    padding: const EdgeInsets.only(left: 3, right: 18),
                    child: Text(
                      "Update time: ${updateTime?.formatDateTime()}",
                      style: TextStyles.textSize12.copyWith(color: context.textColor3),
                    ),
                  ),
                ],
              ),
            );
          },
          selector: (_, provider) => provider.entity?.updateTime,
        ),
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
  SecureNotesProvider prepareProvider() {
    // VaultItemSecureNoteContent: implement prepareProvider
    return SecureNotesProvider();
  }

  @override
  String get title => S.current.tabSecureNotes;

  @override
  void onEditPress() {
    //try to save
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!provider.editing) {
      provider.editing = true;
      return;
    }
    provider.editing = false;
    provider.secureNodeUpdate(
        title: _secureTitle.currentState!.text,
        note: _secureNote.currentState!.text).then((succeed) {
     if (succeed) {
       Toast.showSuccess("Item saved");
       provider.hasChange = true;
       // NavigatorUtils.goBackWithParams(context, {"changed": true});
     } else {
       Toast.showError("Failed to save item");
     }
    });

  }

  @override
  void onCancelPress() {
    provider.tags = [...widget.data?.tags ?? []];
    _tagKey.currentState?.resetTag();
  }

  @override
  Widget buildPopupMenu() {
    if (widget.data == null) return Gaps.empty;
    return super.buildPopupMenu();
  }
}
