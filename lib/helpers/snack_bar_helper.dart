import 'package:flutter/material.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class SnackBarHelper {
  static void showMessage(
    BuildContext context, {
    required String text,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        backgroundColor: isError ? AppTheme.givt4KidsRed : null,
      ),
    );
  }
}
