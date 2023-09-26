import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:givt_app_kids/features/history/history_logic/history_cubit.dart';
import 'package:givt_app_kids/features/history/models/allowance.dart';
import 'package:givt_app_kids/features/profiles/widgets/allowance_item.dart';
import 'package:givt_app_kids/features/profiles/widgets/donation_item.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';
import 'package:go_router/go_router.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEDE4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEEDE4),
        elevation: 0,
        title: const Heading2(text: 'My Givts'),
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/back_btn.svg'),
          color: const Color(0xFF3B3240),
          onPressed: () => context.goNamed(Pages.wallet.name),
        ),
      ),
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
          return ListView.separated(
            padding: const EdgeInsets.all(0),
            itemCount: state.history.length,
            itemBuilder: (BuildContext context, int index) {
              if (state.history[index] is Allowance) {
                return AllowanceItemWidget(allowance: state.history[index]);
              }
              return DonationItemWidget(donation: state.history[index]);
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
