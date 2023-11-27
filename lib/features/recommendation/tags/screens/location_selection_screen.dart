import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/recommendation/tags/cubit/tags_cubit.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';
import 'package:givt_app_kids/features/recommendation/tags/widgets/location_card.dart';
import 'package:givt_app_kids/features/recommendation/widgets/recommendation_givy_bubble.dart';
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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ),
            automaticallyImplyLeading: false,
            leading: const GivtBackButton(),
          ),
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Container(
            width: double.maxFinite,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gradient.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RecommendationGivyBubble(
                      text: state is TagsStateFetching
                          ? 'Give me a moment to think'
                          : 'Where do you want to help?',
                    ),
                    if (state is TagsStateFetching)
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.2),
                        child: LoadingAnimationWidget.waveDots(
                            color: AppTheme.givt4KidsBlue,
                            size: size.width * 0.2),
                      ),
                    if (state is TagsStateFetched)
                      GridView.count(
                        childAspectRatio: 1 / 1.055,
                        crossAxisCount: 2,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shrinkWrap: true,
                        children: state.locations.reversed
                            .map((item) => LocationCard(
                                  location: item,
                                  width: size.width * 0.45,
                                  isSelected: item == state.selectedLocation,
                                  onPressed: () {
                                    context
                                        .read<TagsCubit>()
                                        .selectLocation(location: item);
                                  },
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: state is! TagsStateFetching
              ? FloatingActoinButton(
                  text: "Next",
                  onPressed: state is TagsStateFetched &&
                          state.selectedLocation != const Tag.empty()
                      ? () {
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
                )
              : null,
        );
      },
    );
  }
}
