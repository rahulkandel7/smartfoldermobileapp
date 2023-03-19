import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/core/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthDataSources {
  Future<String> login(var data);
  Future<String> register(var data);
  Future<String> logout();

  //For Sending Code in gmail
  Future<String> sendPasswordResetLink(var data);

  //For Checking Code
  Future<String> checkCode(var data);

  //For Changeing Forget Password
  Future<String> forgetChnagePassword(var data);
}

final authDataSourceProvider = Provider<AuthDataSources>((ref) {
  return AuthDataSourcesImpl(ref.watch(apiServiceProvider));
});

class AuthDataSourcesImpl extends AuthDataSources {
  final ApiService _apiService;

  AuthDataSourcesImpl(this._apiService);
  @override
  Future<String> login(data) async {
    final result = await _apiService.postData(endPoint: 'login', data: data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', result['token']);
    return result['message'];
  }

  @override
  Future<String> register(data) async {
    final result = await _apiService.postData(endPoint: 'register', data: data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', result['token']);
    return result['message'];
  }

  @override
  Future<String> logout() async {
    final result = await _apiService.postDataWithAuthorize(endPoint: 'logout');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    return result['message'];
  }

  @override
  Future<String> sendPasswordResetLink(var data) async {
    final result =
        await _apiService.postData(endPoint: 'password/email', data: data);

    return result['message'];
  }

  @override
  Future<String> checkCode(data) async {
    final result =
        await _apiService.postData(endPoint: 'password/code/check', data: data);
    return result['message'];
  }

  @override
  Future<String> forgetChnagePassword(data) async {
    final result =
        await _apiService.postData(endPoint: 'password/reset', data: data);
    return result['message'];
  }
}
