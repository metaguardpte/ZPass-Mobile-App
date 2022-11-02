import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/vault/login/login_detail_helper.dart';
import 'package:zpass/modules/vault/model/vault_item_secure_note_content.dart';
import 'package:zpass/modules/vault/secure_notes/secure_notes_icon.dart';
import 'package:zpass/modules/vault/secure_notes/secure_notes_provider.dart';
import 'package:zpass/modules/vault/vault_detail_base_state.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/styles.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/zpass_form_edittext.dart';

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
  static const double itemHeight = 30, space = 12;

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
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                width: 1,
                color: const Color.fromRGBO(190, 193, 255, 1),
              )),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            prefix ?? Gaps.empty,
            Text(
              text,
              style: TextStyles.textSize14
                  .copyWith(color: color ?? context.textColor1),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ])),
    );
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
                              filled: true,
                              enable: editing,
                              bgColor: Colors.white,
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
                            buildHint(context, S.current.note, star: editing),
                            Gaps.vGap8,
                            ZPassFormEditText(
                              initialText: provider.content?.note,
                              key: _secureNote,
                              hintText: emptyHint,
                              filled: true,
                              enable: editing,
                              enablePrefix: false,
                              enableClear: editing,
                              enableCopy: !editing,
                              maxLines: 5,
                              bgColor: Colors.white,
                              borderColor:
                                  const Color.fromRGBO(235, 235, 238, 1),
                              height: 70,
                              maxLength: 100,
                            ),
                          ],
                        ),
                      ),
                      Gaps.vGap16,
                      Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 18, bottom: 18),
                        alignment: Alignment.centerLeft,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(11))),
                        child: Column(
                          children: [
                            buildHint(context, S.current.tipsLoading,
                                star: editing),
                            Gaps.vGap12,
                            Container(
                              alignment: Alignment.centerLeft,
                              child: buildTags(editing),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            selector: (_, provider) => provider.content));
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
    provider.secureNodeUpdate(
        title: _secureTitle.currentState!.text,
        note: _secureNote.currentState!.text).then((value) => Log.d('value.toString() ${value.toString()}'));
    provider.editing = !provider.editing;
  }
}
