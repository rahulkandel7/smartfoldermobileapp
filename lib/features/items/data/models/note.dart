class Note {
  final int id;
  final String title;
  final String description;
  final String assetId;

  Note(
      {required this.assetId,
      required this.description,
      required this.id,
      required this.title});

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      assetId: map['asset_id'].toString(),
    );
  }
}
