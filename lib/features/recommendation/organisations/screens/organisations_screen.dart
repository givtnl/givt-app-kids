import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/recommendation/organisations/cubit/organisations_cubit.dart';
import 'package:givt_app_kids/features/recommendation/organisations/widgets/organisation_item.dart';
import 'package:givt_app_kids/features/recommendation/widgets/recommendation_givy_bubble.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
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
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
          ),
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gradient.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    leading: GivtBackButton(),
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
                      title: RecommendationGivyBubble(
                        text: state is OrganisationsFetchingState
                            ? 'Loading...'
                            : state.organisations.isEmpty
                                ? 'Oops, something went wrong...'
                                : 'These charities fit your interests!',
                      ),
                    ),
                  ),
                  if (state is OrganisationsFetchingState)
                    LoadingAnimationWidget.waveDots(
                        color: const Color(0xFF54A1EE), size: 50),
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
          ),
        );
      },
    );
  }
}
