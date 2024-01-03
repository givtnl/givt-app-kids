import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/exhibition_flow/widgets/organisation_item.dart';
import 'package:givt_app_kids/features/profiles/widgets/coin_widget.dart';
import 'package:givt_app_kids/features/recommendation/organisations/cubit/organisations_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
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
                'Cannot find organizations. Please try again later. ${state.errorMessage}',
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
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                const SliverAppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  leading: GivtBackButton(),
                  actions: [
                    Row(
                      children: [
                        Text(
                          '\$10',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w900),
                        ),
                        CoinWidget(),
                      ],
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 16),
                  sliver: SliverAppBar(
                    elevation: 4,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    forceMaterialTransparency: true,
                    automaticallyImplyLeading: false,
                    toolbarHeight: 80,
                    title: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        state is OrganisationsFetchingState
                            ? 'Loading...'
                            : state.organisations.isEmpty
                                ? 'Oops, something went wrong...'
                                : 'Which organisation would you\nlike to give to?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
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
                          color: AppTheme.givt4KidsBlue, size: 100),
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
