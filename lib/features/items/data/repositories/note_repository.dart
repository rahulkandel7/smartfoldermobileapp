import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/core/api/api_error.dart';
import 'package:justsanppit/core/api/dio_exception.dart';
import 'package:justsanppit/features/items/data/models/note.dart';
import 'package:justsanppit/features/items/data/sources/note_data_source.dart';

abstract class NoteRepository {
  Future<Either<ApiError, List<Note>>> fetchNote(int id);
  Future<Either<ApiError, String>> addNote(var data);
  Future<Either<ApiError, String>> deleteNote(int id);
  Future<Either<ApiError, String>> updateNote(int id, var data);
}

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepositoryImpl(ref.watch(noteDataSourceProvider));
});

class NoteRepositoryImpl extends NoteRepository {
  final NoteDataSource _noteDataSource;

  NoteRepositoryImpl(this._noteDataSource);

  @override
  Future<Either<ApiError, String>> addNote(data) async {
    try {
      final result = await _noteDataSource.addNote(data);
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }

  @override
  Future<Either<ApiError, String>> deleteNote(int id) async {
    try {
      final result = await _noteDataSource.deleteNote(id);
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }

  @override
  Future<Either<ApiError, List<Note>>> fetchNote(int id) async {
    try {
      final result = await _noteDataSource.fetchNote(id);
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }

  @override
  Future<Either<ApiError, String>> updateNote(int id, data) async {
    try {
      final result = await _noteDataSource.updateNote(id, data);
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }
}
