import 'dart:developer';
import 'dart:io';

import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DownloadGivtAppWidget extends StatefulWidget {
  @override
  State<DownloadGivtAppWidget> createState() => _DownloadGivtAppWidgetState();
}

class _DownloadGivtAppWidgetState extends State<DownloadGivtAppWidget> {
  var _isGivt4KidsAppInstalled = true;

  @override
  void initState() {
    _initialise();
    super.initState();
  }

  Future<void> _initialise() async {
    final isAppInstalled = await _checkIfGivt4KidsAppInstalled();

    setState(() {
      _isGivt4KidsAppInstalled = isAppInstalled;
    });
  }

  Future<bool> _checkIfGivt4KidsAppInstalled() async {
    try {
      final String appUrl;
      if (Platform.isIOS) {
        appUrl = 'appscheme://net.givtapp.ios';
      } else if (Platform.isAndroid) {
        final currentAppInfo = await PackageInfo.fromPlatform();
        if (currentAppInfo.packageName.contains('.test')) {
          appUrl = 'net.givtapp.droid2.test';
        } else {
          appUrl = 'net.givtapp.droid2';
        }
      } else {
        return false;
      }

      final givtApp = await AppCheck.checkAvailability(appUrl);
      if (givtApp != null) {
        log('${givtApp.appName} is installed on the device.');
        return true;
      }
    } on PlatformException {
      log('Givt App is not installed on the device.');
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return _isGivt4KidsAppInstalled
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: AppTheme.downloadAppBackground),
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
          );
  }
}
