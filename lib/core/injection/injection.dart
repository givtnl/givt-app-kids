import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:givt_app_kids/core/app/app_config.dart';
import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/auth/repositories/auth_repository.dart';
import 'package:givt_app_kids/features/avatars/repositories/avatars_repository.dart';
import 'package:givt_app_kids/features/edit_profile/repositories/edit_profile_repository.dart';
import 'package:givt_app_kids/features/impact_groups/repository/impact_groups_repository.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/repositories/organisation_details_repository.dart';
import 'package:givt_app_kids/features/history/history_repository/history_repository.dart';
import 'package:givt_app_kids/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app_kids/features/recommendation/organisations/repositories/organisations_repository.dart';
import 'package:givt_app_kids/features/recommendation/tags/repositories/tags_repository.dart';
import 'package:givt_app_kids/helpers/svg_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init(AppConfig config) async {
  await _initCoreDependencies();
  _initAPIService(config.apiBaseUrl);
  _initRepositories();
}

void _initAPIService(String baseUrl) {
  getIt.allowReassignment = true;

  log('Using API URL: $baseUrl');
  getIt.registerLazySingleton<APIService>(
    () => APIService(baseUrl),
  );
}

Future<void> _initCoreDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
}

void _initRepositories() {
  getIt.allowReassignment = true;

  getIt
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<ProfilesRepository>(
      () => ProfilesRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<OrganisationDetailsRepository>(
      () => OrganisationDetailsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<CreateTransactionRepository>(
      () => CreateTransactionRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<TagsRepository>(
      () => TagsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<OrganisationsRepository>(
      () => OrganisationsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<SvgAssetLoaderManager>(
      () => SvgAssetLoaderManager(),
    )
    ..registerLazySingleton<AvatarsRepository>(
      () => AvatarsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<EditProfileRepository>(
      () => EditProfileRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<ImpactGroupsRepository>(
      () => ImpactGroupsRepositoryImpl(
        getIt(),
      ),
    );
}
