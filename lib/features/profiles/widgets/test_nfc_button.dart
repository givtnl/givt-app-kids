import 'package:flutter/material.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:go_router/go_router.dart';
import 'package:nfc_manager/nfc_manager.dart';

class TestNFCButton extends StatelessWidget {
  const TestNFCButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: NfcManager.instance.isAvailable(),
      builder: (context, ss) => ss.data != true
          ? Center(child: Text('NfcManager is not available: ${ss.data}'))
          : ElevatedButton(
              onPressed: () => context.goNamed(Pages.test.name),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.maxFinite, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Test NFC',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF1EAE2),
                ),
              )),
    );
  }
}
