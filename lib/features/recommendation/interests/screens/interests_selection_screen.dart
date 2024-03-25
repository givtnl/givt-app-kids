import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/core/injection/injection.dart';
import 'package:givt_app_kids/features/recommendation/interests/cubit/interests_cubit.dart';
import 'package:givt_app_kids/features/recommendation/interests/widgets/interest_card.dart';
import 'package:givt_app_kids/features/recommendation/interests/widgets/interests_tally.dart';
import 'package:givt_app_kids/features/recommendation/widgets/recommendation_givy_bubble.dart';
import 'package:givt_app_kids/helpers/svg_manager.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';

import 'package:go_router/go_router.dart';

class InterestsSelectionScreen extends StatelessWidget {
  const InterestsSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterestsCubit, InterestsState>(
      builder: (context, state) {
        final svgManager = getIt<SvgAssetLoaderManager>();

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
                  const SliverPadding(
                    padding: EdgeInsets.only(top: 16),
                    sliver: SliverAppBar(
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      toolbarHeight: 80,
                      title: RecommendationGivyBubble(
                        text: 'I want to help people...',
                        secondaryText: 'Select your top 3 choices',
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 16),
                    sliver: SliverAppBar(
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Select your top 3 choices',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(width: 8),
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
                      vertical: 32,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return InterestCard(
                            interest: state.interests[index],
                            picture: svgManager.buildSvgPicture(
                                state.interests[index].pictureUrl),
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
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
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
