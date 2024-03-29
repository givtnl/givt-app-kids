import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/core/injection/injection.dart';
import 'package:givt_app_kids/features/recommendation/tags/cubit/tags_cubit.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';
import 'package:givt_app_kids/features/recommendation/tags/widgets/city_card.dart';
import 'package:givt_app_kids/features/recommendation/tags/widgets/location_card.dart';
import 'package:givt_app_kids/features/recommendation/widgets/charity_finder_app_bar.dart';
import 'package:givt_app_kids/helpers/svg_manager.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

class LocationSelectionScreen extends StatelessWidget {
  const LocationSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagsCubit, TagsState>(
      builder: (context, state) {
        final svgManager = getIt<SvgAssetLoaderManager>();
        final isCitySelection = state.status == LocationSelectionStatus.city;
        return Scaffold(
          appBar: const CharityFinderAppBar(),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(top: 16),
                  sliver: SliverAppBar(
                    backgroundColor: Colors.transparent,
                    forceMaterialTransparency: true,
                    automaticallyImplyLeading: false,
                    title: Text(
                      state is TagsStateFetching
                          ? 'Give me a moment to think'
                          : isCitySelection
                              ? 'Which City?'
                              : 'Where do you want to help?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                if (state is TagsStateFetched)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    sliver: isCitySelection
                        ? SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                var items = state.hardcodedCities;
                                return CityCard(
                                    index: index,
                                    isSelected: items[index]['cityName'] ==
                                        state.selectedCity,
                                    onPressed: () {
                                      context
                                          .read<TagsCubit>()
                                          .selectCity(index);
                                    });
                              },
                              childCount: state.hardcodedCities.length,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              // ratio based on figma w/h
                              childAspectRatio: 150 / 200,
                            ),
                          )
                        : SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                var items = state.locations.reversed.toList();
                                return LocationCard(
                                  location: items[index],
                                  isSelected:
                                      items[index] == state.selectedLocation,
                                  onPressed: () {
                                    context
                                        .read<TagsCubit>()
                                        .selectLocation(location: items[index]);
                                  },
                                );
                              },
                              childCount: state.locations.length,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              // ratio based on figma w/h
                              childAspectRatio: 150 / 200,
                            ),
                          ),
                  )
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: state is! TagsStateFetching
              ? GivtElevatedButton(
                  isDisabled: state is TagsStateFetched &&
                          state.selectedLocation != const Tag.empty()
                      ? isCitySelection && state.selectedCity.isEmpty
                          ? true
                          : false
                      : true,
                  text: "Next",
                  onTap: state is TagsStateFetched &&
                          state.selectedLocation != const Tag.empty()
                      ? () {
                          if (state.selectedLocation.key == "STATE" &&
                              state.status == LocationSelectionStatus.general) {
                            context.read<TagsCubit>().goToCitySelection();
                            return;
                          }
                          svgManager.preloadSvgAssets(state.interests
                              .map((e) => e.pictureUrl)
                              .toList());
                          context.pushNamed(
                            Pages.interestsSelection.name,
                            extra: state,
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
