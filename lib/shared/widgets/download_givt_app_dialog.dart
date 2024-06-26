import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadGivtAppDialog extends StatelessWidget {
  const DownloadGivtAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppTheme.primary40.withOpacity(0.3),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 50,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/mayor_avatar.svg',
                  height: 140,
                ),
                Text(
                  'Well done!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "If you enjoyed this, grab your Generosity Challenge pack before you leave. You'll also need the Givt app to start the challenge.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                GivtElevatedButton(
                  onTap: () {
                    if (Platform.isAndroid || Platform.isIOS) {
                      final appId = Platform.isAndroid
                          ? 'net.givtapp.droid2'
                          : '1181435988';
                      final url = Uri.parse(
                        Platform.isAndroid
                            ? "market://details?id=$appId"
                            : "https://apps.apple.com/app/id$appId",
                      );
                      launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  text: 'Download Givt',
                  leftIcon: FontAwesomeIcons.download,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
