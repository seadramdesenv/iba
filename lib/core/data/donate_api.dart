import 'package:iba_member_app/core/data/dio_client.dart';
import 'package:iba_member_app/core/data/models/donate/donate_grid.dart';
import 'package:iba_member_app/core/data/models/donate/donate_insert.dart';
import 'package:iba_member_app/core/data/models/donate/donate_insert_signature.dart';
import 'package:iba_member_app/core/data/models/donate/donate_item_insert.dart';
import 'package:iba_member_app/core/data/models/donor/donor_insert.dart';
import 'package:iba_member_app/core/data/models/donor/donor_search_result.dart';

class DonateApi {
  final DioClient _dioClient;

  DonateApi({required DioClient dioClient}) : _dioClient = dioClient;

  Future<List<DonorSearchResult>> donorSearch(String name) async {
    var response = await _dioClient.instance.get("/donor/$name");
    return (response.data as List).map((item) => DonorSearchResult.fromJson(item)).toList();
  }

  Future<DonorSearchResult> insert(DonorInsertRequest request) async {
    var response = await _dioClient.instance.post(
      "/donor",
      data: request.toJson(),
    );
    return DonorSearchResult(id: response.data, name: request.name, cpf: request.cpf);
  }

  Future<String> insertDonate(DonateInsert request) async {
    var response = await _dioClient.instance.post(
      "/donate",
      data: request.toJson(),
    );
    return response.data;
  }

  Future<void> insertItemDonate(DonateItemInsert request) async {
    await _dioClient.instance.post(
      "/donate/Item",
      data: request.toJson(),
    );
  }

  Future<void> insertDonateSignature(DonateInsertSignature request) async {
    await _dioClient.instance.post(
      "/donate/Signature",
      data: request.toJson(),
    );
  }

  Future<List<DonateGrid>> getDonates({int skip = 1, int take = 20}) async {
    var response = await _dioClient.instance.get("/donate?skip=$skip&take=$take");
    return (response.data as List).map((item) => DonateGrid.fromJson(item)).toList();
  }
}
