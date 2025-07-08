import 'package:iba_member_app/core/data/donate_api.dart';
import 'package:iba_member_app/core/data/models/donate/donate_grid.dart';
import 'package:iba_member_app/core/data/models/donate/donate_insert.dart';
import 'package:iba_member_app/core/data/models/donate/donate_insert_signature.dart';
import 'package:iba_member_app/core/data/models/donate/donate_item_insert.dart';
import 'package:iba_member_app/core/data/models/donor/donor_insert.dart';
import 'package:iba_member_app/core/data/models/donor/donor_search_result.dart';
import 'package:iba_member_app/service_locator.dart';

class DonateController {
  final api = getIt<DonateApi>();

  Future<List<DonorSearchResult>> searchDonor(String query) => api.donorSearch(query);
  Future<DonorSearchResult> insertDonor(DonorInsertRequest request) => api.insert(request);
  Future<String> insertDonate(DonateInsert request) => api.insertDonate(request);
  Future<void> insertItemDonate(DonateItemInsert request) => api.insertItemDonate(request);
  Future<void> insertDonateSignature(DonateInsertSignature request) => api.insertDonateSignature(request);
  Future<List<DonateGrid>> getDonates({int skip = 1, int take = 20}) => api.getDonates(skip: skip, take: take);
}