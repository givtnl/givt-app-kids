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
  const SearchForCoinScreen({super.key, required this.mediumId});
  final String mediumId;

  @override
  Widget build(BuildContext context) {
    final coinCubit = context.read<SearchCoinCubit>();
    return BlocConsumer<SearchCoinCubit, SearchCoinState>(
      listener: (context, coinState) {
        if (coinState.status == CoinAnimationStatus.animating) {
          context
              .read<OrganisationDetailsCubit>()
              .getOrganisationDetails(mediumId);
        }
      },
      builder: (context, coinState) {
        return BlocConsumer<OrganisationDetailsCubit, OrganisationDetailsState>(
          listener: (context, orgState) async {
            if (orgState is OrganisationDetailsSetState) {
              // checking if the request took less than the animation duration
              log("Organisation is set: ${orgState.organisation.name}");
              coinCubit.stopAnimation(coinState);
            }
            if (orgState is OrganisationDetailsErrorState) {
              // checking if the request took less than the animation duration
              log("ERROR");
              coinCubit.stopAnimation(coinState);
            }
          },
          builder: (BuildContext context, orgState) {
            return Scaffold(
              backgroundColor: const Color(0xFFEEEDE4),
              body: coinState.status == CoinAnimationStatus.animating
                  ? const SearchingForCoinPage()
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

                            context.pushNamed(Pages.profileSelectionCoin.name);
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
