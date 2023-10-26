import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';

class CoinErrorPage extends StatelessWidget {
  const CoinErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Something went wrong :( \nPlease try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF54A1EE),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.read<OrganisationDetailsCubit>().getOrganisationDetails(
                    context.read<OrganisationDetailsCubit>().state.mediumId);
                context.read<SearchCoinCubit>().startAnimation();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}