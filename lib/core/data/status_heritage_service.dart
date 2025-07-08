import 'package:iba_member_app/core/data/dio_client.dart';
import 'package:iba_member_app/core/data/models/auto_complete.dart';

class StatusHeritageService{
  final DioClient _dioClient;


  StatusHeritageService({required DioClient dioClient})  : _dioClient = dioClient;

  Future<List<AutoCompleteApi>> autoCompleteApi() async {
    var response = await _dioClient.instance.get("/StatusHeritage");
    if (response.data is List) {
      return (response.data as List)
          .map((item) => AutoCompleteApi.fromJson(item))
          .toList();
    } else {
      throw Exception("Erro: resposta inesperada da API");
    }
  }
}