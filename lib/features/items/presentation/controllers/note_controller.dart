import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/features/items/data/models/note.dart';
import 'package:justsanppit/features/items/data/repositories/note_repository.dart';

class NoteController extends StateNotifier<AsyncValue<List<Note>>> {
  final int id;
  final NoteRepository _noteRepository;
  NoteController(this.id, this._noteRepository) : super(const AsyncLoading()) {
    fetchNote(id);
  }

  fetchNote(int id) async {
    final result = await _noteRepository.fetchNote(id);
    result.fold(
        (error) => state =
            AsyncError(error.message, StackTrace.fromString(error.message)),
        (success) => state = AsyncData(success));
  }

  Future<List<String>> addNote(var data) async {
    final result = await _noteRepository.addNote(data);
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      return msg;
    });
  }

  Future<List<String>> deleteNote(int id) async {
    final result = await _noteRepository.deleteNote(id);
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      return msg;
    });
  }

  Future<List<String>> updateNote(int id, var data) async {
    final result = await _noteRepository.updateNote(id, data);
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      return msg;
    });
  }
}

final noteControllerProvider =
    StateNotifierProvider.family<NoteController, AsyncValue<List<Note>>, int>(
        (ref, id) {
  return NoteController(id, ref.watch(noteRepositoryProvider));
});
