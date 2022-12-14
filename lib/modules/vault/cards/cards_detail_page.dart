import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/vault/cards/cards_detail_provider.dart';
import 'package:zpass/modules/vault/model/vault_item_cards_content.dart';
import 'package:zpass/modules/vault/vault_detail_base_state.dart';
import 'package:zpass/modules/vault/vault_detail_helper.dart';
import 'package:zpass/modules/vault/vault_detail_tags.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/styles.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/extension/int_ext.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/load_image.dart';
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
  final _holderKey = GlobalKey<ZPassFormEditTextState>();
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
                _buildOptionalSection(editing),
                Gaps.vGap15,
                _buildTips(),
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
      holder: _holderKey.currentState!.text,
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
      provider.hasChange = true;
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
    _holderKey.currentState?.fillText(provider.content?.holder ?? "");
    _expiryKey.currentState?.fillText(provider.content?.expiry ?? "");
    _cvvKey.currentState?.fillText(provider.content?.cvv ?? "");
    _zipCodeKey.currentState?.fillText(provider.content?.zipOrPostalCode ?? "");
    _cardPinKey.currentState?.fillText(provider.content?.pin ?? "");
    _otherKey.currentState?.fillText(provider.content?.note ?? "");
  }

  Widget _buildRequiredSection(bool editing) {
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
              prefixIcon: _buildCardIcon(),
              require: true,
              key: _titleKey,
              validator: _validatorEditText,
            ),
            Gaps.vGap15,
            _buildRow(
              editing,
              S.current.vaultCardNumber,
              text: provider.content?.number,
              maxLength: 19,
              require: true,
              key: _numberKey,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _validatorEditText,
              onUnFocus: () => provider.cardNumber = _numberKey.currentState?.text,
              inputFormatters: [
                MaskTextInputFormatter(mask: "#### #### #### #### ###")
              ]
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
          _buildRow(editing, S.current.vaultCardholderName, text: provider.content?.holder, key: _holderKey,),
          Gaps.vGap15,
          _buildRow(editing, S.current.vaultExpiryDate,
            hint: "mm/yy",
            text: provider.content?.expiry,
            key: _expiryKey,
            inputFormatters: [MaskTextInputFormatter(mask: "##/##")],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          Gaps.vGap15,
          _buildRow(editing, S.current.vaultCVV, obscure: true, text: provider.content?.cvv, maxLength: 4, key: _cvvKey),
          Gaps.vGap15,
          _buildRow(editing, S.current.vaultZipOrPostalCode, text: provider.content?.zipOrPostalCode, key: _zipCodeKey),
          Gaps.vGap15,
          _buildRow(editing, S.current.vaultCardPIN, obscure: true, text: provider.content?.pin, maxLength: 12, key: _cardPinKey),
          Gaps.vGap15,
          _buildRow(editing, S.current.vaultOther, text: provider.content?.note, maxLines: 3, key: _otherKey),
          _buildTagContainer(editing),
        ],
      ),
    );
  }

  Widget _buildCardIcon() {
    return Selector<CardsDetailProvider, String?>(
      builder: (_, number, __) {
        final type = parseVaultCardsIcon(number ?? "");
        if (type == null) {
          return buildRowIcon(
            context,
            ZPassIcons.favCard,
            backgroundColor: const Color(0xFF3FD495),
            color: Colors.white,
          );
        }
        return SizedBox(
          width: 34,
          height: 34,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: LoadAssetImage(type),
          ),
        );
      },
      selector: (_, provider) => provider.cardNumber,
    );
  }

  Widget _buildRow(bool editing, String title,
      {String? text,
        Key? key,
        String? hint,
        int maxLines = 1,
        int maxLength = 100,
        Widget? prefixIcon,
        bool obscure = false,
        bool require = false,
        TextInputType? keyboardType,
        NullParamCallback? onUnFocus,
        final List<TextInputFormatter>? inputFormatters,
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
            maxLines: maxLines,
            enableClear: editing,
            filled: !editing,
            maxLength: maxLength,
            keyboardType: keyboardType,
            borderColor: const Color(0xFFEBEBEE),
            validator: validator,
            inputFormatters: inputFormatters,
            onUnFocus: onUnFocus,
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

  Widget _buildTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<CardsDetailProvider, int?>(
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

  String? _validatorEditText(value) {
    if (value == null || value.isEmpty) {
      return "Please enter item name";
    }
    return null;
  }

}
