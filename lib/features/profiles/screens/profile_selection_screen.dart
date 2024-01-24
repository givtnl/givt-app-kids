import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/flows/cubit/flow_type.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/features/profiles/widgets/coin_widget.dart';
import 'package:givt_app_kids/features/profiles/widgets/logout_button.dart';
import 'package:givt_app_kids/features/profiles/widgets/parent_overview_widget.dart';
import 'package:givt_app_kids/features/profiles/widgets/profile_item.dart';
import 'package:givt_app_kids/features/profiles/widgets/profiles_empty_state_widget.dart';

import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/loading_progress_indicator.dart';
import 'package:go_router/go_router.dart';

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({Key? key}) : super(key: key);

  static const int maxVivibleProfiles = 4;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final flow = context.read<FlowsCubit>().state;

    List<Widget> createGridItems(List<Profile> profiles) {
      List<Widget> gridItems = [];
      for (var i = 0, j = 0;
          i < profiles.length && i < maxVivibleProfiles;
          i++, j++) {
        gridItems.add(
          GestureDetector(
            onTap: () {
              context.read<ProfilesCubit>().fetchProfile(profiles[i].id);

              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvent.profilePressed,
                eventProperties: {
                  "profile_name":
                      '${profiles[i].firstName} ${profiles[i].lastName}',
                },
              );

              if (flow.isQRCode) {
                context.pushNamed(Pages.camera.name);
                return;
              }
              if (flow.isRecommendation) {
                context.pushNamed(Pages.recommendationStart.name);
                return;
              }
              if (flow.flowType == FlowType.deepLinkCoin) {
                context.pushNamed(Pages.chooseAmountSlider.name);
                return;
              }
              if (flow.isCoin) {
                context.pushNamed(Pages.scanNFC.name);
                return;
              }
              context.pushReplacementNamed(Pages.wallet.name);
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
        final gridItems = createGridItems(
            state.profiles.where((e) => e.type == 'Child').toList());
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const GivtBackButton(),
            title: Text(
              'My Family',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            actions: [
              if (flow.isCoin) const CoinWidget(),
            ],
          ),
          body: state is ProfilesLoadingState
              ? const LoadingProgressIndicator()
              : state.profiles.isEmpty
                  ? ProfilesEmptyStateWidget(
                      onRetry: () =>
                          context.read<ProfilesCubit>().fetchAllProfiles(),
                    )
                  : SafeArea(
                      child: Column(
                        children: [
                          flow.flowType == FlowType.none
                              ? ParentOverviewWidget(
                                  profiles: state.profiles
                                      .where((p) => p.type == 'Parent')
                                      .toList(),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.1),
                          const Text(
                            'Who would like to give?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.defaultTextColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
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
                                      childAspectRatio: 0.95,
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
                          SizedBox(height: 100)
                        ],
                      ),
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
