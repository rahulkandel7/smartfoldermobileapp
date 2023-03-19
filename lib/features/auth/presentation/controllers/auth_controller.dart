import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/features/auth/data/repositories/auth_data_repository.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthDataRepository _authDataRepository;
  AuthController(this._authDataRepository) : super(const AsyncLoading());

  Future<List<String>> login(data) async {
    final result = await _authDataRepository.login(data);
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      return msg;
    });
  }

  Future<List<String>> register(data) async {
    final result = await _authDataRepository.register(data);
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      return msg;
    });
  }

  Future<List<String>> logout() async {
    final result = await _authDataRepository.logout();
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      return msg;
    });
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authDataRepositoryProvider));
});
