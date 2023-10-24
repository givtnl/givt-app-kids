import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/coin_founded.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/search_coin_animated_widget.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
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
            log('orgState" $orgState');

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Error setting organisation. Please try again later.",
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Theme.of(context).errorColor,
                ),
              );
            }
          },
          builder: (BuildContext context, orgState) {
            log('builder: orgState: $orgState');
            return Scaffold(
              backgroundColor: const Color(0xFFEEEDE4),
              body: coinState.status == CoinAnimationStatus.animating
                  ? const SearchingForCoinPage()
                  : coinState.status == CoinAnimationStatus.error
                      ? const CoinErrorPage()
                      : const CoinFoundPage(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton:
                  coinState.status == CoinAnimationStatus.stoped
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

                            context.pushReplacementNamed(
                                Pages.profileSelectionCoin.name);
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

class CoinErrorPage extends StatelessWidget {
  const CoinErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Something went wrong :( \nPlease try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF54A1EE),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.read<OrganisationDetailsCubit>().getOrganisationDetails(
                    context.read<OrganisationDetailsCubit>().state.mediumId);
                context.read<SearchCoinCubit>().startAnimation();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchingForCoinPage extends StatelessWidget {
  const SearchingForCoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 150),
            child: Text(
              "Scanning the coin...",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF3B3240),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: SearchCoinAnimatedWidget(),
          ),
        ),
      ],
    );
  }
}

class CoinFoundPage extends StatelessWidget {
  const CoinFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 150),
            child: Column(
              children: [
                Text(
                  "Found it!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3B3240),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Let's assign the coin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3B3240),
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: SearchCoinAnimatedWidget(),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: CoinFounded(),
          ),
        ),
      ],
    );
  }
}
