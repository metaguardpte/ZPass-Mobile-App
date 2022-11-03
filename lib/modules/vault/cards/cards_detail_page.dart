import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/vault/cards/cards_detail_provider.dart';
import 'package:zpass/modules/vault/model/vault_item_cards_content.dart';
import 'package:zpass/modules/vault/vault_detail_base_state.dart';
import 'package:zpass/modules/vault/vault_detail_helper.dart';
import 'package:zpass/modules/vault/vault_detail_tags.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/zpass_card.dart';
import 'package:zpass/widgets/zpass_form_edittext.dart';

class CardsDetailPage extends StatefulWidget {
  const CardsDetailPage({Key? key, this.data}) : super(key: key);

  final VaultItemEntity? data;

  @override
  State<CardsDetailPage> createState() => _CardsDetailPageState();
}

class _CardsDetailPageState extends BaseVaultPageState<CardsDetailPage, CardsDetailProvider> {

  final _formKey = GlobalKey<FormState>();
  final _titleKey = GlobalKey<ZPassFormEditTextState>();
  final _numberKey = GlobalKey<ZPassFormEditTextState>();
  final _expiryKey = GlobalKey<ZPassFormEditTextState>();
  final _cvvKey = GlobalKey<ZPassFormEditTextState>();
  final _zipCodeKey = GlobalKey<ZPassFormEditTextState>();
  final _cardPinKey = GlobalKey<ZPassFormEditTextState>();
  final _otherKey = GlobalKey<ZPassFormEditTextState>();
  final _tagKey = GlobalKey<VaultDetailTagsState>();

  @override
  void initState() {
    super.initState();
    provider.analyticsData(widget.data);
  }

  @override
  Widget buildBody(bool editing) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Selector<CardsDetailProvider, VaultItemCardsContent?>(
          builder: (_, content, __) {
            _fillFormTextValue();
            return Column(
              children: [
                _buildRequiredSection(editing),
                Gaps.vGap15,
                _buildOptionalSection(editing)
              ],
            );
          },
          selector: (_, provider) => provider.content,
      ),
    );
  }

  @override
  prepareProvider() {
    return CardsDetailProvider();
  }

  @override
  String get title => S.current.tabCreditCards;

  @override
  void onEditPress() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!provider.editing) {
      provider.editing = true;
      return;
    }
    provider.editing = false;
    provider.update(
      title: _titleKey.currentState!.text,
      number: _numberKey.currentState!.text,
      expiry: _expiryKey.currentState!.text,
      cvv: _expiryKey.currentState!.text,
      zipCode: _expiryKey.currentState!.text,
      pin: _cardPinKey.currentState!.text,
      note: _otherKey.currentState!.text,
    ).then((value) {
      if (!value) {
        Toast.showError("Save fail");
        return;
      }
      Toast.showSuccess("Save success");
      // NavigatorUtils.goBackWithParams(context, {"changed": true});
    }).catchError((error) {
      Toast.showSpec(error.toString(), type: ToastType.error);
    });
  }

  @override
  void onCancelPress() {
    provider.tags = widget.data?.tags ?? [];
    _tagKey.currentState?.resetTag();
  }

  @override
  Widget buildPopupMenu() {
    if (widget.data == null) return Gaps.empty;
    return super.buildPopupMenu();
  }

  void _fillFormTextValue() {
    _titleKey.currentState?.fillText(provider.content?.title ?? "");
    _numberKey.currentState?.fillText(provider.content?.number ?? "");
    _expiryKey.currentState?.fillText(provider.content?.expiry ?? "");
    _cvvKey.currentState?.fillText(provider.content?.cvv ?? "");
    _zipCodeKey.currentState?.fillText(provider.content?.zipOrPostalCode ?? "");
    _cardPinKey.currentState?.fillText(provider.content?.pin ?? "");
    _otherKey.currentState?.fillText(provider.content?.note ?? "");
  }

  Widget _buildRequiredSection(bool editing) {
    final titleIcon = buildRowIcon(context, ZPassIcons.favCard, backgroundColor: const Color(0xFF3FD495), color: Colors.white,);
    return ZPassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildRow(
              editing,
              S.current.vaultTitle,
              text: provider.content?.title,
              prefixIcon: titleIcon,
              require: true,
              key: _titleKey,
            ),
            Gaps.vGap15,
            _buildRow(
              editing,
              S.current.vaultCardNumber,
              text: provider.content?.number,
              require: true,
              key: _numberKey,
              keyboardType: const TextInputType.numberWithOptions(decimal: true)
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalSection(bool editing) {
    return ZPassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Column(
        children: [
          _buildRow(editing, S.current.vaultExpiryDate, hint: "mm/yy", text: provider.content?.expiry, key: _expiryKey,),
          Gaps.vGap15,
          _buildRow(editing, S.current.vaultCVV, obscure: true, text: provider.content?.cvv, key: _cvvKey),
          Gaps.vGap15,
          _buildRow(editing, S.current.vaultZipOrPostalCode, text: provider.content?.zipOrPostalCode, key: _zipCodeKey),
          Gaps.vGap15,
          _buildRow(editing, S.current.vaultCardPIN, obscure: true, text: provider.content?.pin, key: _cardPinKey),
          Gaps.vGap15,
          _buildRow(editing, S.current.vaultOther, text: provider.content?.note, key: _otherKey),
          _buildTagContainer(editing),
        ],
      ),
    );
  }

  Widget _buildRow(bool editing, String title,
      {String? text,
        Key? key,
        String? hint,
        Widget? prefixIcon,
        bool obscure = false,
        bool require = false,
        TextInputType? keyboardType,
        FunctionReturn<String?, dynamic>? validator}) {
    return Container(
      child: Column(
        children: [
          buildHint(context, title, require: editing && require),
          Gaps.vGap8,
          ZPassFormEditText(
            key: key,
            hintText: hint ?? S.current.vaultNone,
            prefix: prefixIcon,
            enablePrefix: prefixIcon != null,
            enableCopy: !editing,
            readOnly: !editing,
            obscureText: obscure,
            enableClear: editing,
            filled: !editing,
            keyboardType: keyboardType,
            borderColor: const Color(0xFFEBEBEE),
            validator: validator ?? _validatorEditText,
          )
        ],
      ),
    );
  }

  Widget _buildTagContainer(bool editing) {
    return VaultDetailTags(
      key: _tagKey,
      tags: provider.tags,
      editing: editing,
      onTagChange: (value) => provider.tags = value,
    );
  }

  String? _validatorEditText(value) {
    if (value == null || value.isEmpty) {
      return "Please enter item name";
    }
    return null;
  }
}
