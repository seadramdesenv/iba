import 'package:iba_member_app/core/data/dio_client.dart';
import 'package:iba_member_app/core/data/models/address_api.dart';

class AddressService {
  final DioClient _dioClient;

  AddressService({required DioClient dioClient})  : _dioClient = dioClient;

  Future<AddressApi> searchZipCode(String zipCode) async {
    try {
      var response = await _dioClient.instance.get("/address/$zipCode");

      if (response.data != null && response.data is Map<String, dynamic>) {
        return AddressApi.fromJson(response.data);
      } else {
        throw Exception("Erro: resposta inesperada da API");
      }
    } catch (e) {
      throw Exception("Erro ao buscar o CEP: $e");
    }
  }
}