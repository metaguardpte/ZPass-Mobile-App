enum VaultItemSortType {
  lastUsed,
  createTime,
}

extension VaultItemSortTypeExt on VaultItemSortType {
  String get desc {
    switch (this) {
      case VaultItemSortType.lastUsed: return "Last Used";
      case VaultItemSortType.createTime: return "Create Time";
    }
  }
}