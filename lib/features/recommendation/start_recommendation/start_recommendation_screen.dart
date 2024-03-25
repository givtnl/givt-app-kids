import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button_flat.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

class StartRecommendationScreen extends StatelessWidget {
  const StartRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: GivtBackButtonFlat(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onPrimary,
          ),
          title: Text(
            'Charity Finder',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          )),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 44),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Hi there!\n',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const TextSpan(
                    text: "Let's find charities that you like",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SvgPicture.asset(
                'assets/images/charity_finder_superhero.svg',
                alignment: Alignment.centerLeft,
                width: MediaQuery.sizeOf(context).width * .7,
              ),
            ),
            GivtElevatedButton(
              isDisabled: false,
              text: "Start",
              onTap: () =>
                  context.pushReplacementNamed(Pages.locationSelection.name),
            ),
          ],
        ),
      ),
    );
  }
}
