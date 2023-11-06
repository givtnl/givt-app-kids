import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:givt_app_kids/features/history/history_logic/history_cubit.dart';
import 'package:givt_app_kids/features/history/models/allowance.dart';
import 'package:givt_app_kids/features/history/models/donation.dart';
import 'package:givt_app_kids/features/history/models/history_item.dart';
import 'package:givt_app_kids/features/history/widgets/history_app_bar.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/shared/widgets/allowance_item_widget.dart';
import 'package:givt_app_kids/shared/widgets/donation_item_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    final childId = context.read<ProfilesCubit>().state.activeProfile.id;
    final historyCubit = context.read<HistoryCubit>();
    final Size size = MediaQuery.of(context).size;
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
              if (state.history[index].type == HistoryTypes.allowance) {
                return AllowanceItemWidget(
                    allowance: state.history[index] as Allowance);
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: DonationItemWidget(
                    donation: state.history[index] as Donation),
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
