import 'package:dio/dio.dart';

class DioException implements Exception {
  DioException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.unknown:
        message = "Connection failed due to internet connection";
        break;
      case DioErrorType.badResponse:
        message = _handleError(
            dioError.response!.statusCode!, dioError.response!.data);
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String? message;

  String _handleError(int statuscode, dynamic error) {
    switch (statuscode) {
      case 400:
        final errorMsg = error as Map<String, dynamic>;
        String msg = '';
        errorMsg.forEach((key, value) {
          msg = value.toString().replaceAll('[', '').replaceAll(']', '');
        });
        return msg;
      case 401:
        return error['detail'];
      case 404:
        return 'Page Not Found';
      case 409:
        return error["message"] ?? "Error";
      case 422:
        if (error['details'] != null) {
          return error["details"].toString();
        } else {
          return error["message"] ?? "Something went wrong";
        }
      case 500:
        return "Internal server error";
      case 503:
        return "Internal server error";
      default:
        return "Something went wrong";
    }
  }
}
