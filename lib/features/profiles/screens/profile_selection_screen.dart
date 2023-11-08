import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/flows/cubit/flow_type.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/features/profiles/widgets/coin_widget.dart';
import 'package:givt_app_kids/features/profiles/widgets/logout_button.dart';
import 'package:givt_app_kids/features/profiles/widgets/profile_item.dart';
import 'package:givt_app_kids/features/profiles/widgets/profiles_empty_state_widget.dart';

import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/loading_progress_indicator.dart';
import 'package:go_router/go_router.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({Key? key}) : super(key: key);

  static const int maxVivibleProfiles = 4;

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
    final flow = context.read<FlowsCubit>().state;

    for (var i = 0, j = 0;
        i < profiles.length && i < ProfileSelectionScreen.maxVivibleProfiles;
        i++, j++) {
      gridItems.add(
        GestureDetector(
          onTap: () {
            _selectProfile(profiles[i]);

            if (flow.isCoin) {
              if (profiles[i].wallet.balance < 1) {
                SnackBarHelper.showMessage(
                  context,
                  text:
                      '${profiles[i].firstName} has no money. Please top up first.',
                );
                return;
              }

              if (flow.flowType == FlowType.deepLinkCoin) {
                context.pushNamed(Pages.chooseAmountSlider.name);
              } else {
                context.pushNamed(Pages.scanNFC.name);
              }
            } else if (flow.isQRCode) {
              context.pushNamed(Pages.camera.name);
            } else {
              context.pushReplacementNamed(Pages.wallet.name);
            }
          },
          child: ProfileItem(
            name: profiles[i].firstName,
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
    final flow = context.read<FlowsCubit>().state;

    return BlocConsumer<ProfilesCubit, ProfilesState>(
      listener: (context, state) {
        if (state is ProfilesExternalErrorState) {
          log(state.errorMessage);
          SnackBarHelper.showMessage(
            context,
            text: 'Cannot download profiles. Please try again later.',
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final gridItems = _createGridItems(state.profiles);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const GivtBackButton(),
            actions: [
              if (flow.isCoin) const CoinWidget(),
            ],
          ),
          body: state is ProfilesLoadingState
              ? const LoadingProgressIndicator()
              : state.profiles.isEmpty
                  ? ProfilesEmptyStateWidget(
                      onRetry: _fetchProfiles,
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 50,
                              right: 50,
                              top: size.height * 0.10,
                              bottom: size.height * 0.03),
                          child: const Text(
                            'Who would like to give?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.defaultTextColor,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton:
              (flow.flowType == FlowType.none && state is! ProfilesLoadingState)
                  ? const LogoutButton()
                  : null,
        );
      },
    );
  }
}
