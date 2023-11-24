import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/recommendation/organisations/cubit/organisations_cubit.dart';
import 'package:givt_app_kids/features/recommendation/organisations/widgets/organisation_item.dart';
import 'package:givt_app_kids/features/recommendation/widgets/recommendation_givy_bubble.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OrganisationsScreen extends StatelessWidget {
  const OrganisationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              'charities_names':
                  state.organisations.map((e) => e.name).toList().toString(),
              'page_name': Pages.recommendedOrganisations.name,
            },
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/gradient.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                ),
                // toolbarHeight: 0,
                automaticallyImplyLeading: false,
                leading: const GivtBackButton(),
              ),
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RecommendationGivyBubble(
                        text: state is OrganisationsFetchingState
                            ? 'Loading...'
                            : state.organisations.isEmpty
                                ? 'Oops, something went wrong...'
                                : 'These charities fit your interests!',
                      ),
                      const SizedBox(height: 20),
                      if (state is OrganisationsFetchingState)
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.25),
                          child: LoadingAnimationWidget.waveDots(
                              color: const Color(0xFF54A1EE),
                              size: size.width * 0.2),
                        ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: state.organisations
                                .map(
                                  (organisation) => OrganisationItem(
                                    width: size.width * .8,
                                    height: size.width * .8,
                                    organisation: organisation,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
