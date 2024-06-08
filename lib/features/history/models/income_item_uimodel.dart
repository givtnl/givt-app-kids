import 'dart:ui';

import 'package:givt_app_kids/features/history/models/history_item.dart';
import 'package:givt_app_kids/features/history/models/income.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/datetime_extension.dart';

class IncomeItemUIModel {
  const IncomeItemUIModel({required this.income, required this.name});

  final Income income;
  final String name;

  String get leadingSVGAsset => 'assets/images/donation_states_added.svg';
  double get amount => income.amount;
  Color get amountColor => const Color(0xFF06509B);
  bool get amountShowPlus => true;
  String get title => income.type == HistoryTypes.topUp
      ? 'Yay! $name can continue making a difference'
      : 'Awesome! Your parents added more to your Wallet';
  String get dateText => income.date.formatDate();
  Color get backgroundColor => AppTheme.historyAllowanceColor;
}
