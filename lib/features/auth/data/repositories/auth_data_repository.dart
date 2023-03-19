import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/core/api/api_error.dart';
import 'package:justsanppit/core/api/dio_exception.dart';
import 'package:justsanppit/features/auth/data/sources/auth_data_sources.dart';

abstract class AuthDataRepository {
  Future<Either<ApiError, String>> login(data);
  Future<Either<ApiError, String>> register(data);
  Future<Either<ApiError, String>> logout();
}

final authDataRepositoryProvider = Provider<AuthDataRepository>((ref) {
  return AuthDataRepositoryImpl(ref.watch(authDataSourceProvider));
});

class AuthDataRepositoryImpl extends AuthDataRepository {
  final AuthDataSources _authDataSources;

  AuthDataRepositoryImpl(this._authDataSources);
  @override
  Future<Either<ApiError, String>> login(data) async {
    try {
      final result = await _authDataSources.login(data);
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }

  @override
  Future<Either<ApiError, String>> logout() async {
    try {
      final result = await _authDataSources.logout();
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }

  @override
  Future<Either<ApiError, String>> register(data) async {
    try {
      final result = await _authDataSources.register(data);
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }
}
