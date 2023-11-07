import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/flows.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/coin_error_page.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/coin_found_page.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/coin_search_page.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';
import 'package:go_router/go_router.dart';

class SearchForCoinScreen extends StatelessWidget {
  const SearchForCoinScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final coinCubit = context.read<SearchCoinCubit>();
    return BlocBuilder<SearchCoinCubit, SearchCoinState>(
      builder: (context, coinState) {
        return BlocConsumer<OrganisationDetailsCubit, OrganisationDetailsState>(
          listener: (context, orgState) async {
            if (orgState is OrganisationDetailsSetState) {
              log("Organisation is set: ${orgState.organisation.name}");
              AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvent.nfcScanned,
                  eventProperties: {
                    'goal_name': orgState.organisation.name,
                  });
              coinCubit.stopAnimation();
            }
            if (orgState is OrganisationDetailsErrorState) {
              coinCubit.error();
              SnackBarHelper.showMessage(
                context,
                text: 'Error setting organisation. Please try again later.',
                isError: true,
              );
            }
          },
          builder: (BuildContext context, orgState) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
              ),
              body: coinState.status == CoinAnimationStatus.animating
                  ? const SearchingForCoinPage()
                  : coinState.status == CoinAnimationStatus.error
                      ? const CoinErrorPage()
                      : const CoinFoundPage(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: coinState.status ==
                      CoinAnimationStatus.stopped
                  ? FloatingActoinButton(
                      text: "Assign the coin",
                      onPressed: () {
                        AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvent.buttonPressed,
                            eventProperties: {
                              'button_name': 'Assign the coin',
                              'formatted_date':
                                  DateTime.now().toIso8601String(),
                              'screen_name': Pages.searchForCoin.name,
                            });

                        final isLoggedIn =
                            context.read<AuthCubit>().state is LoggedInState;
                        final pageName = isLoggedIn
                            ? Pages.profileSelection.name
                            : Pages.login.name;

                        context.pushNamed(
                          pageName,
                          extra: Flows.coin,
                        );
                      },
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
