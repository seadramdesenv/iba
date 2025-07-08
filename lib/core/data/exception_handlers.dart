import 'package:dio/dio.dart';

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r, Response? response): super(requestOptions: r, response: response);

  @override
  String toString() {
    if(response != null){
      return response!.data["message"];
    }

    return "Invalid request";
  }
}
class InternalServerException extends DioException {
  InternalServerException(RequestOptions r): super(requestOptions: r);

  @override
  String toString() {
    return "Unknown error ocurred, please try again later.";
  }
}
