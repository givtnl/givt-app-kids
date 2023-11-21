import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/recommendation/tags/cubit/tags_cubit.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';
import 'package:givt_app_kids/features/recommendation/tags/widgets/location_card.dart';
import 'package:givt_app_kids/features/recommendation/widgets/recommendation_givy_bubble.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LocationSelectionScreen extends StatelessWidget {
  const LocationSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<TagsCubit, TagsState>(
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/gradient.png',
                fit: BoxFit.cover,
              ),
            ),
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: AppTheme.offWhite,
                ),
                // toolbarHeight: 0,
                automaticallyImplyLeading: false,
                leading: const GivtBackButton(),
              ),
              backgroundColor: Colors.transparent,
              body: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      RecommendationGivyBubble(
                        text: state is TagsStateFetching
                            ? 'Loading...'
                            : 'Where do you want to help?',
                      ),
                      SizedBox(height: size.height * 0.20),
                      if (state is TagsStateFetching)
                        Center(
                          child: LoadingAnimationWidget.waveDots(
                              color: const Color(0xFF54A1EE),
                              size: size.width * 0.2),
                        ),
                      if (state is TagsStateFetched)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: state.locations.reversed
                                .map((item) => LocationCard(
                                      location: item,
                                      width: size.width * 0.31,
                                      isSelected:
                                          item == state.selectedLocation,
                                      onPressed: () {
                                        context
                                            .read<TagsCubit>()
                                            .selectLocation(location: item);
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActoinButton(
                text: "Next",
                onPressed: state is TagsStateFetched &&
                        state.selectedLocation != const Tag.empty()
                    ? () {
                        AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvent.nextToInterestsPressed,
                          eventProperties: {
                            'location': state.selectedLocation.displayText,
                            'page_name': Pages.locationSelection.name,
                          },
                        );

                        context.pushNamed(
                          Pages.interestsSelection.name,
                          extra: state,
                        );
                        context.read<TagsCubit>().selectLocation(
                              location: const Tag.empty(),
                              logAmplitude: false,
                            );
                      }
                    : null,
              ),
            )
          ],
        );
      },
    );
  }
}
