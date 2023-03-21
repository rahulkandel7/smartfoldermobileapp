import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/api_constants.dart';
import 'package:justsanppit/core/api/dio_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  //* Post Data for Login,Register,Forget Password
  postData({required String endPoint, required data}) async {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.url,
      ),
    );

    try {
      final result = await dio.post(endPoint, data: data);
      return result.data;
    } on DioError catch (e) {
      throw DioException.fromDioError(e);
    }
  }

//* Post Data for adding assets,items and notes
  postDataWithAuthorize({required String endPoint, data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Dio dio = Dio(
      BaseOptions(baseUrl: ApiConstants.url, headers: {
        'Authorization': 'Bearer ${prefs.getString('token')}',
      }),
    );

    try {
      final result = await dio.post(endPoint, data: data);
      return result.data;
    } on DioError catch (e) {
      throw DioException.fromDioError(e);
    }
  }

//* Get Data for user assets,items,notes
  getDatawithAuthorize({required String endpoint}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.url,
        headers: {'Authorization': 'Bearer ${prefs.getString('token')}'},
      ),
    );

    try {
      final result = await dio.get(endpoint);
      return result.data;
    } on DioError catch (e) {
      throw DioException.fromDioError(e);
    }
  }

  deleteDataWithAuthorize({required String endpoint}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.url,
        headers: {'Authorization': 'Bearer ${prefs.getString('token')}'},
      ),
    );

    try {
      final result = await dio.delete(endpoint);
      return result.data;
    } on DioError catch (e) {
      throw DioException.fromDioError(e);
    }
  }

  updateDataWithAuthorize({required String endpoint, data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.url,
        headers: {
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
      ),
    );

    try {
      final result = await dio.put(endpoint, data: data);
      return result.data;
    } on DioError catch (e) {
      throw DioException.fromDioError(e);
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
