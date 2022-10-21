
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
  vaultItem(name: "vaultItem");

  const EntityType({
    required this.name
  });

  final String name;
}

enum SortBy {
  useTime,
  createTime;
}