import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/recommendation/organisations/cubit/organisations_cubit.dart';
import 'package:givt_app_kids/features/recommendation/organisations/widgets/organisation_item.dart';
import 'package:givt_app_kids/features/recommendation/widgets/charity_finder_app_bar.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OrganisationsScreen extends StatelessWidget {
  const OrganisationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrganisationsCubit, OrganisationsState>(
      listener: (context, state) {
        if (state is OrganisationsExternalErrorState) {
          log(state.errorMessage);
          SnackBarHelper.showMessage(
            context,
            text:
                'Cannot recommend organisations. Please try again later. ${state.errorMessage}',
            isError: true,
          );
        } else if (state is OrganisationsFetchedState) {
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvent.charitiesShown,
            eventProperties: {
              AnalyticsHelper.recommendedCharitiesKey:
                  state.organisations.map((e) => e.name).toList().toString(),
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const CharityFinderAppBar(),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(top: 16),
                  sliver: SliverAppBar(
                    elevation: 4,
                    backgroundColor: Colors.white,
                    forceMaterialTransparency: true,
                    automaticallyImplyLeading: false,
                    toolbarHeight: 80,
                    title: Text(
                      state is OrganisationsFetchingState
                          ? 'Loading...'
                          : state.organisations.isEmpty
                              ? 'Oops, something went wrong...'
                              : 'Which organisation would you\nlike to give to?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                if (state is OrganisationsFetchingState)
                  SliverFillViewport(delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * .3),
                      child: LoadingAnimationWidget.waveDots(
                          color: const Color(0xFF54A1EE), size: 100),
                    );
                  })),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return OrganisationItem(
                            organisation: state.organisations[index]);
                      },
                      childCount: state.organisations.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
