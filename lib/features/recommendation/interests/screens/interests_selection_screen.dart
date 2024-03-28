import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/recommendation/interests/cubit/interests_cubit.dart';
import 'package:givt_app_kids/features/recommendation/interests/widgets/interest_card.dart';
import 'package:givt_app_kids/features/recommendation/interests/widgets/interests_tally.dart';
import 'package:givt_app_kids/features/recommendation/widgets/charity_finder_app_bar.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';

import 'package:go_router/go_router.dart';

class InterestsSelectionScreen extends StatelessWidget {
  const InterestsSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterestsCubit, InterestsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const CharityFinderAppBar(),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(top: 16),
                  sliver: SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.white,
                    surfaceTintColor: AppTheme.primary90,
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select your top 3 choices',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        InterestsTally(
                          tally: state.selectedInterests.length,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return InterestCard(
                          interest: state.interests[index],
                          isSelected: state.selectedInterests
                              .contains(state.interests[index]),
                          onPressed: () {
                            context
                                .read<InterestsCubit>()
                                .selectInterest(state.interests[index]);
                          },
                        );
                      },
                      childCount: state.interests.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      // ratio based on figma w/h
                      childAspectRatio: 150 / 198,
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible:
                state.selectedInterests.length == InterestsState.maxInterests,
            child: GivtElevatedButton(
              isDisabled:
                  state.selectedInterests.length == InterestsState.maxInterests
                      ? false
                      : true,
              text: "Next",
              onTap: state.selectedInterests.length ==
                      InterestsState.maxInterests
                  ? () {
                      context.pushNamed(
                        Pages.recommendedOrganisations.name,
                        extra: state,
                      );
                      context.read<InterestsCubit>().clearSelectedInterests();
                    }
                  : null,
            ),
          ),
        );
      },
    );
  }
}
