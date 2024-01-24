import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/core/injection/injection.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/auth/screens/login_screen.dart';
import 'package:givt_app_kids/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app_kids/features/avatars/widgets/avatar_selection_screen.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/coin_flow/screens/search_for_coin_screen.dart';
import 'package:givt_app_kids/features/coin_flow/screens/success_coin_screen.dart';
import 'package:givt_app_kids/features/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:givt_app_kids/features/exhibition_flow/screens/voucher_code_screen.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/screens/choose_amount_slider_screen.dart';
import 'package:givt_app_kids/features/giving_flow/screens/success_screen.dart';
import 'package:givt_app_kids/features/history/history_logic/history_cubit.dart';
import 'package:givt_app_kids/features/history/history_screen.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/screens/profile_selection_screen.dart';
import 'package:givt_app_kids/features/profiles/screens/wallet_screen.dart';
import 'package:givt_app_kids/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/presentation/camera_screen.dart';
import 'package:givt_app_kids/features/recommendation/interests/cubit/interests_cubit.dart';
import 'package:givt_app_kids/features/recommendation/interests/screens/interests_selection_screen.dart';
import 'package:givt_app_kids/features/recommendation/organisations/cubit/organisations_cubit.dart';
import 'package:givt_app_kids/features/recommendation/organisations/screens/organisations_screen.dart';
import 'package:givt_app_kids/features/recommendation/start_recommendation/start_recommendation_screen.dart';
import 'package:givt_app_kids/features/recommendation/tags/cubit/tags_cubit.dart';
import 'package:givt_app_kids/features/recommendation/tags/screens/location_selection_screen.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/nfc_scan_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:givt_app_kids/features/exhibition_flow/screens/organisations_screen.dart'
    as exhibition_flow;
import 'package:givt_app_kids/features/exhibition_flow/screens/success_coin_screen.dart'
    as exhibition_flow;

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;
  static final GoRouter _router = GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
          path: Pages.splash.path,
          name: Pages.splash.name,
          redirect: (context, state) {
            final auth = context.read<AuthCubit>().state;
            final profiles = context.read<ProfilesCubit>().state;
            if (auth is LoggedInState) {
              if (profiles.isProfileSelected) {
                context
                    .read<ProfilesCubit>()
                    .fetchActiveProfile(profiles.activeProfile.id);
                return Pages.wallet.path;
              }
              return Pages.profileSelection.path;
            }
            return Pages.login.path;
          },
        ),
        GoRoute(
          path: Pages.login.path,
          name: Pages.login.name,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: Pages.profileSelection.path,
          name: Pages.profileSelection.name,
          builder: (context, state) {
            return const ProfileSelectionScreen();
          },
        ),
        GoRoute(
            path: Pages.wallet.path,
            name: Pages.wallet.name,
            builder: (context, state) {
              return const WalletScreen();
            }),
        GoRoute(
          path: Pages.camera.path,
          name: Pages.camera.name,
          builder: (context, state) => BlocProvider(
            create: (context) => CameraCubit(),
            child: const CameraScreen(),
          ),
        ),
        GoRoute(
          path: Pages.chooseAmountSlider.path,
          name: Pages.chooseAmountSlider.name,
          builder: (context, state) => BlocProvider(
            create: (BuildContext context) =>
                CreateTransactionCubit(context.read<ProfilesCubit>(), getIt()),
            child: const ChooseAmountSliderScreen(),
          ),
        ),
        GoRoute(
          path: Pages.success.path,
          name: Pages.success.name,
          builder: (context, state) => const SuccessScreen(),
        ),
        GoRoute(
          path: Pages.history.path,
          name: Pages.history.name,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: BlocProvider(
              create: (context) => HistoryCubit(getIt())
                ..fetchHistory(
                    context.read<ProfilesCubit>().state.activeProfile.id),
              child: const HistoryScreen(),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(2.0, 0.0),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.ease)),
                        ),
                        child: child),
          ),
        ),
        GoRoute(
          path: Pages.recommendationStart.path,
          name: Pages.recommendationStart.name,
          builder: (context, state) => const StartRecommendationScreen(),
        ),
        GoRoute(
          path: Pages.locationSelection.path,
          name: Pages.locationSelection.name,
          builder: (context, state) => BlocProvider(
            create: (context) => TagsCubit(
              getIt(),
            )..fetchTags(),
            child: const LocationSelectionScreen(),
          ),
        ),
        GoRoute(
          path: Pages.interestsSelection.path,
          name: Pages.interestsSelection.name,
          builder: (context, state) {
            final extra = state.extra ?? TagsStateFetched.empty();
            final tagsState = (extra as TagsStateFetched);
            return BlocProvider(
              create: (context) => InterestsCubit(
                location: tagsState.selectedLocation,
                interests: tagsState.interests,
              ),
              child: const InterestsSelectionScreen(),
            );
          },
        ),
        GoRoute(
          path: Pages.recommendedOrganisations.path,
          name: Pages.recommendedOrganisations.name,
          builder: (context, state) {
            final extra = state.extra ?? InterestsState.empty();
            final interestsState = (extra as InterestsState);
            return BlocProvider(
              create: (context) => OrganisationsCubit(
                getIt(),
              )..getRecommendedOrganisations(
                  location: interestsState.location,
                  interests: interestsState.selectedInterests,
                  fakeComputingExtraDelay: const Duration(seconds: 1),
                ),
              child: const OrganisationsScreen(),
            );
          },
        ),
        GoRoute(
          path: Pages.searchForCoin.path,
          name: Pages.searchForCoin.name,
          redirect: (context, state) => getIt<SharedPreferences>()
                      .getBool('isInAppCoinFlow') ==
                  true
              ? null
              : "${Pages.outAppCoinFlow.path}?code=${state.uri.queryParameters['code']}",
          builder: (context, state) {
            final String mediumID = state.uri.queryParameters['code'] == null ||
                    state.uri.queryParameters['code']!.contains('null')
                ? OrganisationDetailsCubit.defaultMediumId
                : state.uri.queryParameters['code']!;
            // THE USECASE FOR THIS BUILDER IS
            // When the user opens the app from in-app coin flow
            // on andrioid accidentally scanning the coin twice

            // So the flow we need to show is in-app coin flow

            // Because the deeplink opens a whole new app context we need to
            // re-fetch the organisation details
            // & emit the in-app coin flow

            context
                .read<OrganisationDetailsCubit>()
                .getOrganisationDetails(mediumID);

            context.read<FlowsCubit>().startInAppCoinFlow();

            return BlocProvider(
              create: (BuildContext context) => CreateTransactionCubit(
                  context.read<ProfilesCubit>(), getIt()),
              child: const ChooseAmountSliderScreen(),
            );
          },
        ),
        GoRoute(
          path: Pages.outAppCoinFlow.path,
          name: Pages.outAppCoinFlow.name,
          builder: (context, state) {
            final String mediumID =
                state.uri.queryParameters['code']!.contains('null')
                    ? OrganisationDetailsCubit.defaultMediumId
                    : state.uri.queryParameters['code']!;

            context
                .read<OrganisationDetailsCubit>()
                .getOrganisationDetails(mediumID);
            return BlocProvider<SearchCoinCubit>(
              lazy: false,
              create: (context) => SearchCoinCubit()..startAnimation(mediumID),
              child: const SearchForCoinScreen(),
            );
          },
        ),
        GoRoute(
          path: Pages.scanNFC.path,
          name: Pages.scanNFC.name,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => ScanNfcCubit()
                ..readTag(prescanningDelay: ScanNfcCubit.startDelay),
              child: const NFCScanPage(),
            );
          },
        ),
        GoRoute(
          path: Pages.successCoin.path,
          name: Pages.successCoin.name,
          builder: (context, state) => const SuccessCoinScreen(),
        ),
        GoRoute(
          path: Pages.voucherCodeScreen.path,
          name: Pages.voucherCodeScreen.name,
          builder: (context, state) => const VoucherCodeScreen(),
        ),
        GoRoute(
          path: Pages.exhibitionOrganisations.path,
          name: Pages.exhibitionOrganisations.name,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => OrganisationsCubit(
                getIt(),
              )..getRecommendedOrganisations(
                  location: OrganisationsCubit.exhibitionLocation,
                  interests: OrganisationsCubit.exhibitionInterests,
                  pageSize: 10,
                  filterInterests: false,
                ),
              child: const exhibition_flow.OrganisationsScreen(),
            );
          },
        ),
        GoRoute(
          path: Pages.successExhibitionCoin.path,
          name: Pages.successExhibitionCoin.name,
          builder: (context, state) =>
              const exhibition_flow.SuccessCoinScreen(),
        ),
        GoRoute(
          path: Pages.avatarSelection.path,
          name: Pages.avatarSelection.name,
          builder: (context, state) {
            final activeProfile =
                context.read<ProfilesCubit>().state.activeProfile;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AvatarsCubit(
                    getIt(),
                  )..fetchAvatars(),
                ),
                BlocProvider(
                  create: (context) => EditProfileCubit(
                    childGUID: activeProfile.id,
                    editProfileRepository: getIt(),
                    currentProfilePicture: activeProfile.pictureURL,
                  ),
                ),
              ],
              child: const AvatarSelectionScreen(),
            );
          },
        ),
      ]);
}
