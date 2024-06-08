import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/history/models/income_item_uimodel.dart';
import 'package:givt_app_kids/shared/widgets/common_history_item_widget.dart';

class IncomeItemWidget extends StatelessWidget {
  const IncomeItemWidget({required this.uimodel, super.key});
  final IncomeItemUIModel uimodel;
  @override
  Widget build(BuildContext context) {
    return CommonHistoryItemWidget(
      leadingSvgAsset: uimodel.leadingSVGAsset,
      amount: uimodel.amount,
      amountColor: uimodel.amountColor,
      amountShowPlus: uimodel.amountShowPlus,
      name: uimodel.name,
      title: uimodel.title,
      dateText: uimodel.dateText,
      backgroundColor: uimodel.backgroundColor,
    );
  }
}
