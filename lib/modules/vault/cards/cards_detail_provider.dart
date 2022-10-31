import 'package:zpass/modules/home/provider/home_provider.dart';
import 'package:zpass/modules/vault/vault_item_provider.dart';

class CardsDetailProvider extends BaseVaultProvider {
  CardsDetailProvider() : super(HomeProvider().repoDB);
}