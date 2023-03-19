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

  //Send Forget Password Link
  Future<List<String>> sendPasswordResetLink(String email) async {
    var data = {'email': email};
    final result = await _authDataRepository.sendPasswordResetLink(data);
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      return msg;
    });
  }

  //Check Code OTP
  Future<List<String>> codeCheck(String code) async {
    var data = {'code': code};
    final result = await _authDataRepository.codeCheck(data);
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      return msg;
    });
  }

  //Forget Chnage Password
  Future<List<String>> forgetChnagePassword(
      {required String password,
      required String confirmPassword,
      required String code}) async {
    var data = {
      'password': password,
      'code': code,
      'password_confirmation': confirmPassword,
    };

    final result = await _authDataRepository.forgetChangePassword(data);
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
