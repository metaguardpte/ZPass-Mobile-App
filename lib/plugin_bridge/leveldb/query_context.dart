
import 'package:zpass/modules/home/provider/vault_item_type.dart';

class QueryContext {
  String keyword;
  EntityType entityType;
  VaultItemType itemType;
  SortBy sortBy;

  QueryContext(this.keyword, this.entityType, this.itemType, this.sortBy);
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