import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:iba_member_app/core/data/models/auto_complete.dart';
import 'package:iba_member_app/core/data/models/heritage/heritage_grid.dart';
import 'package:iba_member_app/core/data/models/heritage/heritage_insert.dart';

import 'dio_client.dart';

class HeritageApi {
  final DioClient _dioClient;

  HeritageApi({required DioClient dioClient}) : _dioClient = dioClient;

  Future<List<HeritageGrid>> getHeritages({int skip = 1, int take = 20}) async {
    var response = await _dioClient.instance.get("/heritage?skip=$skip&take=$take");
    return (response.data as List).map((item) => HeritageGrid.fromJson(item)).toList();
  }

  Future<List<HeritageGrid>> searchHeritages(String query) async {
    var response = await _dioClient.instance.get("/heritage?q=$query");
    return (response.data as List).map((item) => HeritageGrid.fromJson(item)).toList();
  }

  Future<String> insertHeritage(HeritageInsert request) async {
    var response = await _dioClient.instance.post(
      "/heritage",
      data: request.toJson(),
    );

    return response.data;
  }

  Future<Uint8List> getPdf() async {
    var response = await _dioClient.instance.get(
      "/heritage/PrintSearchApp",
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    return Uint8List.fromList(response.data);
  }

  Future<List<AutoCompleteApi>> autoCompleteStatusApi() async {
    var response = await _dioClient.instance.get("/statusheritage");
    if (response.data is List) {
      return (response.data as List)
          .map((item) => AutoCompleteApi.fromJson(item))
          .toList();
    } else {
      throw Exception("Erro: resposta inesperada da API");
    }
  }
}
