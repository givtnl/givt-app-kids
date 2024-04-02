import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/features/design_alignment_screen/text_styles_column.dart';
import 'package:givt_app_kids/features/profiles/widgets/action_tile.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_fab.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DesignAlignmentScreen extends StatefulWidget {
  const DesignAlignmentScreen({super.key});

  @override
  State<DesignAlignmentScreen> createState() => _DesignAlignmentScreenState();
}

class _DesignAlignmentScreenState extends State<DesignAlignmentScreen> {
  List<bool> scalePixels = [true, false];

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) => Scaffold(
        appBar: AppBar(
          leading: const GivtBackButton(),
          title: Text(
            'Design Alignment Screen',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 24,
                ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Pixel density of this device is ${Device.pixelRatio} \nScale factor of .px: ${1.px.toString()}, \nScale factor of .sp: ${1.sp.toString()}, \nScale factor of .dp: ${1.dp.toString()}, \nScale factor of .pt: ${1.pt.toString()}, \nScale factor of .pc: ${1.pc.toString()}, \n",
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.05),
                child: Row(
                  children: [
                    GivtFloatingActionButton(
                      onTap: () {},
                      text: 'Label',
                      leftIcon: FontAwesomeIcons.solidFaceSmileBeam,
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
                        titleSmall: "Coin",
                        iconPath: 'assets/images/give_with_coin.svg',
                        backgroundColor: AppTheme.highlight98,
                        borderColor: AppTheme.highlight80,
                        textColor: AppTheme.highlight40,
                        onTap: () {}),
                    const SizedBox(width: 16),
                    ActionTile(
                      isDisabled: false,
                      titleSmall: "Find Charity",
                      iconPath: 'assets/images/find_tile.svg',
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      borderColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      textColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GivtElevatedButton(
                onTap: () async {
                  log('design button tapped');

                  final Uri url = Uri.parse(
                      'givt://?mediumid=61f7ed014e4c0321c003.c00000000001&from=givtkids:///wallet');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                text: 'Give on Givt',
                leftIcon: FontAwesomeIcons.house,
              ),
              const SizedBox(height: 20),
              GivtElevatedButton(
                isTertiary: true,
                onTap: () {},
                text: 'Switch Profile',
                leadingImage: SvgPicture.network(
                  'https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero3.svg',
                  height: 34,
                  width: 34,
                ),
              ),
              const TextStylesColumn(),
            ],
          ),
        ),
      ),
    );
  }
}
