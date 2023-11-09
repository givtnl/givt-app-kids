import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/core/injection/injection.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/auth/screens/login_screen.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/coin_flow/screens/search_for_coin_screen.dart';
import 'package:givt_app_kids/features/coin_flow/screens/success_coin_screen.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/screens/choose_amount_slider_screen.dart';
import 'package:givt_app_kids/features/giving_flow/screens/success_screen.dart';
import 'package:givt_app_kids/features/history/history_logic/history_cubit.dart';
import 'package:givt_app_kids/features/history/history_screen.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/screens/profile_selection_screen.dart';
import 'package:givt_app_kids/features/profiles/screens/wallet_screen.dart';
import 'package:givt_app_kids/features/qr_scanner/presentation/camera_screen.dart';
import 'package:givt_app_kids/features/recommendation/cubit/recommendation_cubit.dart';
import 'package:givt_app_kids/features/recommendation/recommendation_screen.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/nfc_scan_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          builder: (context, state) => const ProfileSelectionScreen(),
        ),
        GoRoute(
          path: Pages.wallet.path,
          name: Pages.wallet.name,
          builder: (context, state) => const WalletScreen(),
        ),
        GoRoute(
          path: Pages.camera.path,
          name: Pages.camera.name,
          builder: (context, state) => const CameraScreen(),
        ),
        GoRoute(
          path: Pages.chooseAmountSlider.path,
          name: Pages.chooseAmountSlider.name,
          builder: (context, state) {
            final String mediumID =
                state.uri.queryParameters['code']!.contains('null')
                    ? OrganisationDetailsCubit.defaultMediumId
                    : state.uri.queryParameters['code']!;
            final bool isInAppCoinFlow =
                state.uri.queryParameters['isInAppCoinFlow'] == 'true';
            if (isInAppCoinFlow) {
              context
                  .read<OrganisationDetailsCubit>()
                  .getOrganisationDetails(mediumID);
            }
            return const ChooseAmountSliderScreen();
          },
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
          path: Pages.recommend.path,
          name: Pages.recommend.name,
          builder: (context, state) => BlocProvider<RecommendationCubit>(
            create: (context) => RecommendationCubit(getIt()),
            child: const RecommendationScreen(),
          ),
        ),
        GoRoute(
          path: Pages.searchForCoin.path,
          name: Pages.searchForCoin.name,
          redirect: (context, state) => getIt<SharedPreferences>()
                      .getBool('isInAppCoinFlow') ==
                  true
              ? "${Pages.chooseAmountSlider.path}?code=${state.uri.queryParameters['code']}&isInAppCoinFlow=true"
              : "${Pages.outAppCoinFlow.path}?code=${state.uri.queryParameters['code']}",
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
              create: (context) => SearchCoinCubit()..startAnimation(),
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
                  ..startTagRead(delay: ScanNfcCubit.startDelay),
                child: const NFCScanPage(),
              );
            }),
        GoRoute(
          path: Pages.successCoin.path,
          name: Pages.successCoin.name,
          builder: (context, state) => const SuccessCoinScreen(),
        ),
      ]);
}
