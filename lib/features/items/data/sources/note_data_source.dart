import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/core/api/api_service.dart';
import 'package:justsanppit/features/items/data/models/note.dart';

abstract class NoteDataSource {
  Future<List<Note>> fetchNote(int id);
  Future<String> addNote(var data);
  Future<String> updateNote(int id, var data);
  Future<String> deleteNote(int id);
}

final noteDataSourceProvider = Provider<NoteDataSource>((ref) {
  return NoteDataSourceImpl(ref.watch(apiServiceProvider));
});

class NoteDataSourceImpl extends NoteDataSource {
  final ApiService _apiService;

  NoteDataSourceImpl(this._apiService);

  @override
  Future<String> addNote(data) async {
    await _apiService.postDataWithAuthorize(endPoint: 'notes/', data: data);
    return 'Note added successfully';
  }

  @override
  Future<String> deleteNote(int id) async {
    await _apiService.deleteDataWithAuthorize(endpoint: 'notes/$id/');
    return 'Note removed successfully';
  }

  @override
  Future<List<Note>> fetchNote(int id) async {
    final result = await _apiService.getDatawithAuthorize(endpoint: 'notes/');
    final notes = result as List<dynamic>;
    return notes.map((note) => Note.fromMap(note)).toList();
  }

  @override
  Future<String> updateNote(int id, data) async {
    final result = await _apiService.updateDataWithAuthorize(
        endpoint: 'notes/$id/', data: data);
    return result['message'];
  }
}
