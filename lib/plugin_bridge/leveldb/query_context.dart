
import 'package:zpass/modules/home/provider/vault_item_type.dart';

class QueryContext {
  String keyword;
  EntityType entityType;
  VaultItemType itemType;
  SortBy sortBy;
  bool includeDeleted = false;

  QueryContext(this.keyword, this.entityType, this.itemType, this.sortBy);
  QueryContext.includeDeleted(this.keyword, this.entityType, this.itemType, this.sortBy, this.includeDeleted);
}

enum EntityType {
  vaultItem(name: "vaultItem"),
  passwordHistory(name: "passwordHistory"),
  address(name: "Address"),
  tokenCollection(name: "tokenCollection"),
  tokenMultiSend(name: "tokenMultiSend"),
  tokenInfo(name: "tokenInfo");

  const EntityType({
    required this.name
  });

  final String name;
}

enum SortBy {
  useTime,
  createTime;
}