import 'dart:typed_data';

import 'package:iba_member_app/core/data/heritage_api.dart';
import 'package:iba_member_app/core/data/models/auto_complete.dart';
import 'package:iba_member_app/core/data/models/heritage/heritage_grid.dart';
import 'package:iba_member_app/core/data/models/heritage/heritage_insert.dart';
import 'package:iba_member_app/service_locator.dart';

class HeritageController {
  final api = getIt<HeritageApi>();

  Future<List<HeritageGrid>> getDonates({int skip = 1, int take = 20}) => api.getHeritages(skip: skip, take: take);
  Future<List<HeritageGrid>> searchHeritages(String query) => api.searchHeritages(query);
  Future<Uint8List> getPdf() => api.getPdf();
  Future<List<AutoCompleteApi>> autoCompleteStatusApi() => api.autoCompleteStatusApi();
  Future<String> insertHeritage(HeritageInsert request) => api.insertHeritage(request);
}