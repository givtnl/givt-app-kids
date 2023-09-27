import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:givt_app_kids/features/history/history_logic/history_cubit.dart';
import 'package:givt_app_kids/features/history/models/allowance.dart';
import 'package:givt_app_kids/features/history/widgets/history_app_bar.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/shared/widgets/allowance_item.dart';
import 'package:givt_app_kids/shared/widgets/donation_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    final childId = context.read<ProfilesCubit>().state.activeProfile.id;
    final historyCubit = context.read<HistoryCubit>();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (historyCubit.state.status != HistroryStatus.loading) {
          // Scrolled to end of list try to fetch more data
          historyCubit.fetchHistory(childId);
        }
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFFEEEDE4),
      appBar: const HistoryAppBar(),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state.status == HistroryStatus.loading &&
              historyCubit.state.pageNr < 2) {
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
            controller: scrollController,
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
