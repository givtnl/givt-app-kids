
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/recommendation/organisations/cubit/organisations_cubit.dart';
import 'package:givt_app_kids/features/recommendation/organisations/widgets/organisation_item.dart';
import 'package:givt_app_kids/features/recommendation/widgets/recommendation_givy_bubble.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';

class OrganisationsScreen extends StatelessWidget {
  const OrganisationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganisationsCubit, OrganisationsState>(
      builder: (context, state) {
        return Scaffold(
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

    // @override
    // Widget build(BuildContext context) {
    //   final size = MediaQuery.of(context).size;
    //   return BlocConsumer<OrganisationsCubit, OrganisationsState>(
    //     listener: (context, state) {
    //       if (state is OrganisationsExternalErrorState) {
    //         log(state.errorMessage);
    //         SnackBarHelper.showMessage(
    //           context,
    //           text:
    //               'Cannot recommend organisations. Please try again later. ${state.errorMessage}',
    //           isError: true,
    //         );
    //       } else if (state is OrganisationsFetchedState) {
    //         AnalyticsHelper.logEvent(
    //           eventName: AmplitudeEvent.charitiesShown,
    //           eventProperties: {
    //             AnalyticsHelper.recommendedCharitiesKey:
    //                 state.organisations.map((e) => e.name).toList().toString(),
    //           },
    //         );
    //       }
    //     },
    //           child: SafeArea(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 RecommendationGivyBubble(
    //                   text: state is OrganisationsFetchingState
    //                       ? 'Loading...'
    //                       : state.organisations.isEmpty
    //                           ? 'Oops, something went wrong...'
    //                           : 'These charities fit your interests!',
    //                 ),
    //                 if (state is OrganisationsFetchingState)
    //                   Padding(
    //                     padding: EdgeInsets.only(top: size.height * 0.25),
    //                     child: LoadingAnimationWidget.waveDots(
    //                         color: const Color(0xFF54A1EE),
    //                         size: size.width * 0.2),
    //                   ),
    //                 Expanded(
    //                   child: SingleChildScrollView(
    //                     child: Padding(
    //                       padding: const EdgeInsets.symmetric(
    //                           horizontal: 24, vertical: 10),
    //                       child: Column(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: state.organisations
    //                             .map(
    //                               (organisation) => Padding(
    //                                 padding:
    //                                     const EdgeInsets.symmetric(vertical: 10),
    //                                 child: OrganisationItem(
    //                                   width: double.maxFinite,
    //                                   height: size.height * .4,
    //                                   organisation: organisation,
    //                                 ),
    //                               ),
    //                             )
    //                             .toList(),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(height: 20),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
  }
}
