// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/auth/screens/login_screen.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/features/profiles/widgets/profile_item.dart';
import 'package:givt_app_kids/features/profiles/screens/wallet_screen.dart';

import 'package:givt_app_kids/helpers/analytics_helper.dart';

class ProfileSelectionScreen extends StatefulWidget {
  static const String routeName = "/profile-selection-bloc";

  const ProfileSelectionScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    final parentGuid = (context.read<AuthCubit>().state as LoggedInState).guid;
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
            Navigator.of(context)
                .pushReplacementNamed(WalletScreenCubit.routeName);
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
    return SafeArea(
      child: BlocConsumer<ProfilesCubit, ProfilesState>(
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
          // else if (state is ProfilesUpdatedState) {
          //   log('Active profile is ${state.activeProfile.firstName}');
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(
          //         'Active profile is ${state.activeProfile.firstName} ${state.activeProfile.lastName}',
          //         textAlign: TextAlign.center,
          //       ),
          //     ),
          //   );
          // }
        },
        builder: (context, state) {
          final gridItems = _createGridItems(state.profiles);
          return Scaffold(
            backgroundColor: const Color(0xFFEEEDE4),
            body: state is ProfilesLoadingState
                ? Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF54A1EE),
                    ),
                  )
                : state.profiles.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "There are no profiles attached to the current user.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF54A1EE),
                                  fontSize: 25,
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
                      )
                    : SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(50),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                Text(
                                  "Choose your profile",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF54A1EE),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: gridItems.length == 1 ? 1 : 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  children: gridItems,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: state is ProfilesLoadingState
                ? null
                : FloatingActionButton.extended(
                    backgroundColor: const Color(0xFF374A53),
                    extendedPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                      context
                          .read<ProfilesCubit>()
                          .setActiveProfile(Profile.empty());

                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    label: const Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    icon: const Icon(
                      Icons.logout,
                      size: 25,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
