import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class TestNFCiOSButton extends StatefulWidget {
  const TestNFCiOSButton({super.key});

  @override
  State<TestNFCiOSButton> createState() => _TestNFCiOSButtonState();
}

class _TestNFCiOSButtonState extends State<TestNFCiOSButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _tagRead,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.maxFinite, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        'Test NFC (iOS)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF1EAE2),
        ),
      ),
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      log('ios coin discovered: ${tag.data}');
      var ndef = Ndef.from(tag);
      if (ndef != null && ndef.cachedMessage != null) {
        if (ndef.cachedMessage!.records.isNotEmpty &&
            ndef.cachedMessage!.records.first.typeNameFormat ==
                NdefTypeNameFormat.nfcWellknown) {
          final wellKnownRecord = ndef.cachedMessage!.records.first;
          if (wellKnownRecord.payload.first == 0x02) {
            final languageCodeAndContentBytes =
                wellKnownRecord.payload.skip(1).toList();
            final languageCodeAndContentText =
                utf8.decode(languageCodeAndContentBytes);
            final payload = languageCodeAndContentText.substring(2);
            log('ios coin payload: $payload');
            _showResultSnackBar(payload);
          } else {
            final decoded = utf8.decode(wellKnownRecord.payload);
            log('ios coin decoded: $decoded');
            _showResultSnackBar(decoded);
          }
        }
      }
      NfcManager.instance.stopSession();
    });
  }

  void _showResultSnackBar(String result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 7),
        content: Text(
          "Coin's data: $result",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
