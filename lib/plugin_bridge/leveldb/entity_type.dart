
enum EntityType {
  VaultItem(name: "vaultItem");

  const EntityType({
    required this.name
  });

  final String name;
}