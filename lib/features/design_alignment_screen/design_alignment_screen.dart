import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/features/design_alignment_screen/text_styles_column.dart';
import 'package:givt_app_kids/features/profiles/widgets/action_tile.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_secondary_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_fab.dart';

class DesignAlignmentScreen extends StatelessWidget {
  const DesignAlignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beebee boop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.05),
              child: Row(
                children: [
                  GivtFloatingActionButton(
                    onTap: () {},
                    text: 'Label',
                    leftIcon: const Icon(
                      FontAwesomeIcons.solidFaceSmileBeam,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionTile(
                      isDisabled: false,
                      text: "Coin",
                      iconPath: 'assets/images/give_with_coin.svg',
                      backgroundColor: AppTheme.highlight98,
                      borderColor: AppTheme.highlight80,
                      textColor: AppTheme.highlight40,
                      onTap: () {}),
                  const SizedBox(width: 16),
                  ActionTile(
                    isDisabled: false,
                    text: "Find Charity",
                    iconPath: 'assets/images/find_tile.svg',
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    borderColor: Theme.of(context).colorScheme.primaryContainer,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GivtElevatedButton(
              onTap: () {},
              text: 'Back to Home',
              leftIcon: const Icon(
                FontAwesomeIcons.house,
              ),
            ),
            const SizedBox(height: 20),
            GivtElevatedSecondaryButton(
              onTap: () {},
              text: 'Switch Profile',
              leadingImage: SvgPicture.network(
                'https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero3.svg',
                height: 32,
                width: 32,
              ),
            ),
            const TextStylesColumn(),
          ],
        ),
      ),
    );
  }
}
