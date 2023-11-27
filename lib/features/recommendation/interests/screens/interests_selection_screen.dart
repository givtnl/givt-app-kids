import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/recommendation/interests/cubit/interests_cubit.dart';
import 'package:givt_app_kids/features/recommendation/interests/widgets/interest_card.dart';
import 'package:givt_app_kids/features/recommendation/interests/widgets/interests_tally.dart';
import 'package:givt_app_kids/features/recommendation/widgets/recommendation_givy_bubble.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';

import 'package:go_router/go_router.dart';

class InterestsSelectionScreen extends StatelessWidget {
  const InterestsSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<InterestsCubit, InterestsState>(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RecommendationGivyBubble(
                    text: 'I want to help people...',
                    secondaryText: 'Select your top 3 choices',
                    extraChild: InterestsTally(
                      tally: state.selectedInterests.length,
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      childAspectRatio: 1 / 1.055,
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                      shrinkWrap: false,
                      children: state.interests
                          .map((item) => InterestCard(
                                interest: item,
                                width: size.width * 0.45,
                                isSelected:
                                    state.selectedInterests.contains(item),
                                onPressed: () {
                                  context
                                      .read<InterestsCubit>()
                                      .selectInterest(item);
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
          floatingActionButton: Visibility(
            visible:
                state.selectedInterests.length == InterestsState.maxInterests,
            child: FloatingActoinButton(
              text: "Next",
              onPressed: state.selectedInterests.length ==
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
