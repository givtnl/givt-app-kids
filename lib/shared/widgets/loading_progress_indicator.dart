import 'package:flutter/material.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class LoadingProgressIndicator extends StatelessWidget {
  const LoadingProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppTheme.givt4KidsBlue,
      ),
    );
  }
}
