import 'package:iba_member_app/core/data/dio_client.dart';
import 'package:iba_member_app/core/data/models/Member.dart';

class MemberApi {
  final DioClient _dioClient;

  MemberApi({required DioClient dioClient}) : _dioClient = dioClient;

  Future<void> insertMember(Member request) async {
    await _dioClient.instance.post(
      "/member",
      data: request.toJson(),
    );
  }

  Future<void> updateMember(Member request) async {
    await _dioClient.instance.put(
      "/member/${request.id}",
      data: request.toJson(),
    );
  }

  Future<Member> getMembers(String id) async {
    var response = await _dioClient.instance.get("/member/$id");
    return Member.fromJson(response.data);
  }

  Future<List<Member>> getMember({int skip = 1, int take = 20}) async {
    var response =
        await _dioClient.instance.get("/member?skip=$skip&take=$take");
    return (response.data as List)
        .map((item) => Member.fromJson(item))
        .toList();
  }

  Future<List<Member>> searchMember(String query) async {
    var response = await _dioClient.instance.get("/member?q=$query");
    return (response.data as List)
        .map((item) => Member.fromJson(item))
        .toList();
  }
}
