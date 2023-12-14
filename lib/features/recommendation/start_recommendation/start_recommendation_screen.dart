import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

class StartRecommendationScreen extends StatelessWidget {
  const StartRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GivtBackButton(
          onPressedExt: () => context.read<FlowsCubit>().resetFlow(),
        ),
        backgroundColor: AppTheme.offWhite,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppTheme.offWhite,
        ),
      ),
      backgroundColor: AppTheme.offWhite,
      body: Column(
        children: [
          Text(
            'Hi there!',
            // style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(
            //   fontSize: 32,
            //   fontWeight: FontWeight.bold,
            //   color: AppTheme.defaultTextColor,
            //   height: 0,
            // ),
          ),
          const SizedBox(height: 6),
          Text(
            "Let's find charities that you like",
            // style: AppTheme.textTheme.displayLarge?.copyWith(
            //   fontSize: 18,
            //   color: AppTheme.defaultTextColor,
            //   fontWeight: FontWeight.w500,
            //   height: 0,
            // ),
          ),
          const Spacer(),
          Center(
            child: SvgPicture.asset(
              'assets/images/givy_bubble_grey.svg',
              alignment: Alignment.centerLeft,
              width: MediaQuery.sizeOf(context).width * .7,
            ),
          ),
          const Spacer(
            flex: 2,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GivtElevatedButton(
        isDisabled: false,
        text: "Start",
        onTap: () => context.pushNamed(Pages.locationSelection.name),
      ),
    );
  }
}
