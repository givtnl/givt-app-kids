import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/recommendation/interests/cubit/interests_cubit.dart';
import 'package:givt_app_kids/features/recommendation/interests/widgets/interest_card.dart';
import 'package:givt_app_kids/features/recommendation/interests/widgets/interests_tally.dart';
import 'package:givt_app_kids/features/recommendation/widgets/recommendation_givy_bubble.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
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
                  statusBarColor: AppTheme.offWhite,
                ),
                // toolbarHeight: 0,
                automaticallyImplyLeading: false,
                leading: const GivtBackButton(),
              ),
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    RecommendationGivyBubble(
                      text: 'I want to help people...',
                      extraChild: InterestsTally(
                        size: size.height,
                        tally: state.selectedInterests.length,
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.08),
                      child: GridView.count(
                        childAspectRatio: 2.5,
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        children: state.interests
                            .map((item) => InterestCard(
                                  interest: item,
                                  width: size.width * 0.30,
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
                    SizedBox(
                      height: size.height * 0.10,
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActoinButton(
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
            )
          ],
        );
      },
    );
  }
}
