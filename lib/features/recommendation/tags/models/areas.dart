import 'package:flutter/material.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

enum Areas {
  environment(
    accentColor: AppTheme.primary70,
    backgroundColor: AppTheme.primary98,
    textColor: AppTheme.primary40,
  ),
  education(
    accentColor: AppTheme.secondary80,
    backgroundColor: AppTheme.secondary98,
    textColor: AppTheme.secondary40,
  ),
  basic(
    accentColor: AppTheme.highlight80,
    backgroundColor: AppTheme.highlight98,
    textColor: AppTheme.highlight40,
  ),
  health(
    accentColor: AppTheme.tertiary80,
    backgroundColor: AppTheme.tertiary98,
    textColor: AppTheme.tertiary40,
  ),
  location(
    accentColor: AppTheme.tertiary80,
    backgroundColor: AppTheme.tertiary98,
    textColor: AppTheme.tertiary40,
  ),
  disaster(
    accentColor: AppTheme.highlight80,
    backgroundColor: AppTheme.highlight98,
    textColor: AppTheme.highlight40,
  ),
  primary(
    accentColor: AppTheme.primary70,
    backgroundColor: AppTheme.primary98,
    textColor: AppTheme.primary40,
  ),
  secondary(
    accentColor: AppTheme.secondary80,
    backgroundColor: AppTheme.secondary98,
    textColor: AppTheme.secondary40,
  ),
  highlight(
    accentColor: AppTheme.highlight80,
    backgroundColor: AppTheme.highlight98,
    textColor: AppTheme.highlight40,
  ),
  tertiary(
    accentColor: AppTheme.tertiary80,
    backgroundColor: AppTheme.tertiary98,
    textColor: AppTheme.tertiary40,
  ),
  ;

  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;

  const Areas({
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
  });

  factory Areas.fromMap(Map<String, dynamic> map) {
    try {
      return Areas.values.byName(
        (map['area'] ?? '').toLowerCase(),
      );
    } on ArgumentError {
      return Areas.location;
    }
  }
}
