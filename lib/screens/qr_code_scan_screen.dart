// ignore_for_file: prefer_const_constructors, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:givt_app_kids/models/profile.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:provider/provider.dart';

//import 'package:givt_app_kids/screens/choose_amount_screen_v4.dart';
import 'package:givt_app_kids/widgets/qr_code_target.dart';
import 'package:givt_app_kids/widgets/back_button.dart' as custom_widgets;
import 'package:givt_app_kids/screens/choose_amount_slider_screen.dart';
import 'package:givt_app_kids/providers/profiles_provider.dart';
import 'package:givt_app_kids/models/organisation.dart';

class QrCodeScanScreen extends StatefulWidget {
  static const String routeName = "/qr-code-scan";

  const QrCodeScanScreen({Key? key}) : super(key: key);

  @override
  State<QrCodeScanScreen> createState() => _QrCodeScanScreenState();
}

class _QrCodeScanScreenState extends State<QrCodeScanScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    AnalyticsHelper.logScreenView(QrCodeScanScreen.routeName);

    //temporary code to test on iOS simulators
    if (kDebugMode && Platform.isIOS) {
      Future.delayed(
        Duration(seconds: 3),
      ).then(
        (_) {
          Navigator.of(context).pushNamed(
            ChooseAmountSliderScreen.routeName,
          );
        },
      );
    }
  }

  Future<Organisation?> _getOrganisationDetails(String? qrCode) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (qrCode == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please scan a Givt QR code.",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return null;
      }

      var organisation =
          await Provider.of<ProfilesProvider>(context, listen: false)
              .getOrganizationDetails(qrCode);
      dev.log(organisation.name);
      return organisation;
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot scan a QR code. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                  color: Color(0xFFEEEDE4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      custom_widgets.BackButton(),
                      Expanded(
                        child: Text(
                          "Scan the Givt\nQR code",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B3240),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 55,
                      ),
                    ],
                  )),
            ),
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  MobileScanner(
//                    allowDuplicates: false,
                    fit: BoxFit.fitWidth,
                    onDetect: (barcode, args) async {
                      if (_isLoading) {
                        return;
                      }

                      var organisation =
                          await _getOrganisationDetails(barcode.rawValue);
                      if (organisation != null && mounted) {
                        Navigator.of(context).pushNamed(
                          ChooseAmountSliderScreen.routeName,
                          arguments: organisation,
                        );
                      }
                    },
                  ),
                  Positioned.fill(
                    child: QrCodeTarget(),
                  ),
                  if (_isLoading)
                    Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
