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
      assetId: map['assest_id'] as int,
      photopath: map['photo'] as String,
    );
  }
}
