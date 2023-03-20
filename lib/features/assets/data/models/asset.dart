class Asset {
  final int id;
  final String name;
  final String photopath;

  Asset({
    required this.id,
    required this.name,
    required this.photopath,
  });

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'] as int,
      name: map['name'] as String,
      photopath: map['photopath'] as String,
    );
  }
}
