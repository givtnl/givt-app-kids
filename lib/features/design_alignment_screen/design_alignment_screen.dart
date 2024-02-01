import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/features/design_alignment_screen/text_styles_column.dart';
import 'package:givt_app_kids/features/profiles/widgets/action_tile.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_fab.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
          leading: BackButton(
            style: IconButton.styleFrom(iconSize: scalePixels[1] ? 24.sp : 24),
          ),
          title: Text(
            'Design Alignment Screen',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: scalePixels[1] ? 24.sp : 24,
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
                      leftIcon: Icon(
                        FontAwesomeIcons.solidFaceSmileBeam,
                        size: scalePixels[1] ? 20.sp : 20,
                      ),
                      scalePixels: scalePixels[1],
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
                        fontSize: scalePixels[1] ? 20.sp : 20,
                        isDisabled: false,
                        text: "Coin",
                        iconPath: 'assets/images/give_with_coin.svg',
                        backgroundColor: AppTheme.highlight98,
                        borderColor: AppTheme.highlight80,
                        textColor: AppTheme.highlight40,
                        onTap: () {}),
                    const SizedBox(width: 16),
                    ActionTile(
                      fontSize: scalePixels[1] ? 20.sp : 20,
                      isDisabled: false,
                      text: "Find Charity",
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
                scalePixels: true,
                onTap: () {},
                text: 'Back to Home',
                leftIcon: Icon(
                  FontAwesomeIcons.house,
                  size: scalePixels[1] ? 24.sp : 24,
                ),
                textStyle: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: scalePixels[1] ? 20.sp : 20),
              ),
              const SizedBox(height: 20),
              GivtElevatedButton(
                scalePixels: true,
                isTertiary: true,
                onTap: () {},
                text: 'Switch Profile',
                leadingImage: SvgPicture.network(
                  'https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero3.svg',
                  height: scalePixels[1] ? 34.sp : 34,
                  width: scalePixels[1] ? 34.sp : 34,
                ),
                textStyle: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: scalePixels[1] ? 20.sp : 20),
              ),
              TextStylesColumn(scalePixels: scalePixels[1]),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: ToggleButtons(
            isSelected: scalePixels,
            onPressed: (index) {
              setState(() {
                for (int i = 0; i < scalePixels.length; i++) {
                  scalePixels[i] = i == index;
                }
              });
            },
            borderWidth: 2,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Theme.of(context).colorScheme.tertiary,
            selectedColor: Theme.of(context).colorScheme.tertiary,
            borderColor: Theme.of(context).colorScheme.tertiaryContainer,
            fillColor: Theme.of(context).colorScheme.tertiaryContainer,
            color: Theme.of(context).colorScheme.tertiaryContainer,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            children: const [Text('.px'), Text('.sp')],
          ),
        ),
      ),
    );
  }
}

double getSize(int index, double nr) {
  if (index == 1) {
    return nr.sp;
  }
  return nr;
}
