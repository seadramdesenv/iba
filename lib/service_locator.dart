import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:iba_member_app/core/Globals.dart';
import 'package:iba_member_app/core/data/address_service.dart';
import 'package:iba_member_app/core/data/dio_client.dart';
import 'package:iba_member_app/core/data/donate_api.dart';
import 'package:iba_member_app/core/data/heritage_api.dart';
import 'package:iba_member_app/core/data/marital_status_service.dart';
import 'package:iba_member_app/core/data/member_service.dart';
import 'package:iba_member_app/core/data/status_heritage_service.dart';
import 'package:iba_member_app/controller/donate_controller.dart';
import 'package:iba_member_app/controller/heritage_controller.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<Dio>(Dio(BaseOptions(baseUrl: Globals.apiBaseUrl)));
  getIt.registerSingleton<DioClient>(DioClient(instance: getIt<Dio>()));

  getIt.registerLazySingleton<MemberApi>(
      () => MemberApi(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<DonateApi>(
      () => DonateApi(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<MaritalStatusService>(
      () => MaritalStatusService(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<StatusHeritageService>(
      () => StatusHeritageService(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<AddressService>(
      () => AddressService(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<HeritageApi>(
      () => HeritageApi(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<DonateController>(() => DonateController());
  getIt.registerLazySingleton<HeritageController>(() => HeritageController());
}
