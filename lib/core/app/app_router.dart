import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/auth/screens/login_screen.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/coin_flow/screens/search_for_coin_screen.dart';
import 'package:givt_app_kids/features/giving_flow/screens/choose_amount_slider_screen.dart';
import 'package:givt_app_kids/features/giving_flow/screens/success_screen.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/screens/profile_selection_screen.dart';
import 'package:givt_app_kids/features/profiles/screens/wallet_screen.dart';
import 'package:givt_app_kids/features/qr_scanner/presentation/camera_screen.dart';
import 'package:go_router/go_router.dart';

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
          builder: (context, state) => const ChooseAmountSliderScreen(),
        ),
        GoRoute(
          path: Pages.success.path,
          name: Pages.success.name,
          builder: (context, state) => const SuccessScreen(),
        ),
        GoRoute(
          path: Pages.searchForCoin.path,
          name: Pages.searchForCoin.name,
          builder: (context, state) => BlocProvider<SearchCoinCubit>(
            lazy: false,
            create: (context) => SearchCoinCubit()..searchForCoin(),
            child: const SearchForCoinScreen(),
          ),
        ),
      ]);
}
