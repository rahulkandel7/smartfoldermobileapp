class Item {
  final int id;
  final int assetId;
  final String photopath;

  Item({
    required this.id,
    required this.photopath,
    required this.assetId,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int,
      assetId: map['asset_id'] as int,
      photopath: map['photopath'] as String,
    );
  }
}
