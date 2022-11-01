import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/vault/cards/cards_detail_provider.dart';
import 'package:zpass/modules/vault/vault_detail_base_state.dart';
import 'package:zpass/modules/vault/vault_detail_helper.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/widgets/zpass_card.dart';
import 'package:zpass/widgets/zpass_edittext.dart';

class CardsDetailPage extends StatefulWidget {
  const CardsDetailPage({Key? key}) : super(key: key);

  @override
  State<CardsDetailPage> createState() => _CardsDetailPageState();
}

class _CardsDetailPageState extends BaseVaultPageState<CardsDetailPage, CardsDetailProvider> {

  @override
  Widget buildBody(bool editing) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        children: [
          _buildTopCard(editing),
          Gaps.vGap15,
          _buildBottomCard(editing)
        ],
      ),
    );
  }

  @override
  prepareProvider() {
    return CardsDetailProvider();
  }

  @override
  // TODO: implement title
  String get title => S.current.tabCreditCards;


  Widget _buildTopCard(bool editing) {
    return ZPassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Form(
        child: Column(
          children: [
            _buildRow(
              editing,
              S.current.vaultTitle,
              prefixIcon: buildRowIcon(
                context,
                ZPassIcons.favCard,
                backgroundColor: const Color(0xFF3FD495),
                color: Colors.white,
              ),
            ),
            Gaps.vGap15,
            _buildRow(editing ,S.current.vaultCardNumber)
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCard(bool editing) {
    return ZPassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Form(
        child: Column(
          children: [
            _buildRow(editing, S.current.vaultExpiryDate, hint: "mm/yy"),
            Gaps.vGap15,
            _buildRow(editing, S.current.vaultCVV, obscure: true),
            Gaps.vGap15,
            _buildRow(editing, S.current.vaultZipOrPostalCode),
            Gaps.vGap15,
            _buildRow(editing, S.current.vaultCardPIN),
            Gaps.vGap15,
            _buildRow(editing, S.current.vaultOther)
          ],
        ),
      ),
    );
  }

  Widget _buildRow(bool editing, String title, {String? hint, Widget? prefixIcon, bool obscure = false}) {
    return Container(
      child: Column(
        children: [
          buildHint(context, title, require: editing),
          Gaps.vGap8,
          ZPassEditText(
            hintText: hint ?? S.current.vaultNone,
            prefix: prefixIcon,
            enablePrefix: prefixIcon != null,
            enableCopy: !editing,
            enableInput: editing,
            obscureText: obscure,
            enableClear: editing,
            bgColor: editing ? Colors.white : null,
            borderColor: const Color(0xFFEBEBEE),
          )
        ],
      ),
    );
  }
}
