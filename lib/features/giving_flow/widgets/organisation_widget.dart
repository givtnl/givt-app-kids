import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/models/organisation_details.dart';

class OrganisationWidget extends StatelessWidget {
  final OrganisationDetails organisation;

  const OrganisationWidget(this.organisation, {super.key});

  @override
  Widget build(BuildContext context) {
    final flow = context.read<FlowsCubit>().state;

    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (flow.isCoin) SvgPicture.asset('assets/images/church.svg'),
          if (flow.isCoin) const SizedBox(width: 24),
          if ((flow.isRecommendation || flow.isExhibition) &&
              organisation.logoLink != null)
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.only(right: 12),
              child: Image.network(
                organisation.logoLink!,
                fit: BoxFit.contain,
              ),
            ),
          BlocBuilder<OrganisationDetailsCubit, OrganisationDetailsState>(
            builder: (context, state) {
              if (state is OrganisationDetailsLoadingState) {
                return const SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                  child: Text(
                    organisation.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
