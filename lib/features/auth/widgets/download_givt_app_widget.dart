import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadGivtAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final appId = Platform.isAndroid ? 'net.givtapp.droid2' : '1181435988';
        final url = Uri.parse(
          Platform.isAndroid
              ? 'market://details?id=$appId'
              : 'https://apps.apple.com/app/id$appId',
        );
        launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //border radius
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppTheme.downloadAppBackground
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: SvgPicture.asset('assets/images/givt_app_logo.svg',
                height: 40, width: 40),
          ),
          const SizedBox(width: 10),
          const Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Download Givt",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                SizedBox(height: 4),
                Text(
                  "If you've not created your family yet, download the Givt app to get started.",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'RadioCanada',
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
