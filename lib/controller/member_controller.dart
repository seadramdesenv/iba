import 'dart:async';
import 'package:iba_member_app/core/data/member_service.dart';
import 'package:iba_member_app/core/data/models/Member.dart';
import 'package:iba_member_app/service_locator.dart';

class MemberController {
  final api = getIt<MemberApi>();

  Future<Member> getMember(String id) async {
    return await api.getMembers(id);
  }

  Future<void> insertMember(Member request) async {
    await api.insertMember(request);
  }

  Future<void> updateMember(Member request) async {
    await api.updateMember(request);
  }

  // Future<void> deleteComment(int id) async {
  //   await api.deleteComment(_movie.id, id);
  //
  //   getMovie();
  // }
  //
  // Future<void> postComment(String comment) async {
  //   await api.postComment(_movie.id, comment);
  //
  //   getMovie();
  // }
}
