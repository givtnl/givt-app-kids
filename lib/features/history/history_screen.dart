import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:givt_app_kids/features/history/history_logic/history_cubit.dart';
import 'package:givt_app_kids/features/history/models/allowance.dart';
import 'package:givt_app_kids/features/history/widgets/history_appbar.dart';
import 'package:givt_app_kids/shared/widgets/allowance_item.dart';
import 'package:givt_app_kids/shared/widgets/donation_item.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEDE4),
      appBar: const HistoryAppBar(),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state.status == HistroryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HistroryStatus.error) {
            return Center(
              child: Text(state.error),
            );
          }
          // Display List of donations and allowances in descending date order
          return ListView.separated(
            padding: const EdgeInsets.all(0),
            itemCount: state.history.length,
            itemBuilder: (BuildContext context, int index) {
              if (state.history[index] is Allowance) {
                return AllowanceItemWidget(allowance: state.history[index]);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DonationItemWidget(donation: state.history[index]),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              thickness: 1,
              height: 1,
              endIndent: 20,
              indent: 20,
            ),
          );
        },
      ),
    );
  }
}
