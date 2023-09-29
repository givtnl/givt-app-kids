// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/features/profiles/widgets/profile_item.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

import 'package:givt_app_kids/shared/widgets/back_button.dart'
    as custom_widgets;
import 'package:go_router/go_router.dart';

class ProfileSelectionCoinScreen extends StatefulWidget {
  const ProfileSelectionCoinScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSelectionCoinScreen> createState() =>
      _ProfileSelectionCoinScreenState();
}

class _ProfileSelectionCoinScreenState
    extends State<ProfileSelectionCoinScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    final parentGuid =
        (context.read<AuthCubit>().state as LoggedInState).session.userGUID;
    context.read<ProfilesCubit>().fetchProfiles(parentGuid);
  }

  Future<void> _selectProfile(Profile profile) async {
    context.read<ProfilesCubit>().setActiveProfile(profile);
    await AnalyticsHelper.logEvent(
      eventName: AmplitudeEvent.profilePressed,
      eventProperties: {
        "profile_name": '${profile.firstName} ${profile.lastName}',
      },
    );
  }

  List<Widget> _createGridItems(List<Profile> profiles) {
    List<Widget> gridItems = [];
    for (var i = 0, j = 0; i < profiles.length && i < 4; i++, j++) {
      gridItems.add(
        GestureDetector(
          onTap: () {
            _selectProfile(profiles[i]);

            if (profiles[i].wallet.balance < 1) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${profiles[i].firstName} has no money. Please top up first.",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
              return;
            }

            context.pushNamed(Pages.chooseAmountSliderCoin.name);
          },
          child: ProfileItem(
            name: '${profiles[i].firstName} ${profiles[i].lastName}',
            imageUrl: profiles[i].pictureURL,
          ),
        ),
      );
    }
    return gridItems;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocConsumer<ProfilesCubit, ProfilesState>(
      listener: (context, state) {
        log('profiles state changed on $state');
        if (state is ProfilesExternalErrorState) {
          log(state.errorMessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Cannot download profiles. Please try again later.",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        final gridItems = _createGridItems(state.profiles);
        return Scaffold(
          backgroundColor: const Color(0xFFEEEDE4),
          body: Column(
            children: [
              SizedBox(height: 35),
              Row(
                children: [
                  custom_widgets.BackButton(),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: SvgPicture.asset(
                      'assets/images/coin_activated_small.svg',
                    ),
                  ),
                ],
              ),
              state is ProfilesLoadingState
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF54A1EE),
                        ),
                      ),
                    )
                  : state.profiles.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "There are no profiles attached to the current user.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF3B3240),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _fetchProfiles(),
                                    icon: Icon(Icons.refresh_rounded),
                                    label: Text("Retry"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 50,
                                  right: 50,
                                  top: size.height * 0.05,
                                  bottom: size.height * 0.01),
                              child: Text(
                                "Who would like to\ngive the coin?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF3B3240),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.height * 0.06),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      GridView.count(
                                        shrinkWrap: true,
                                        crossAxisCount:
                                            gridItems.length == 1 ? 1 : 2,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        children: gridItems,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            ],
          ),
        );
      },
    );
  }
}
