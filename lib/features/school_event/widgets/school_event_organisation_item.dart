import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app_kids/features/recommendation/organisations/widgets/organisation_header.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/features/school_event/widgets/school_event_organisation_detail_bottom_sheet.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/action_container.dart';

class SchoolEventOrganisationItem extends StatelessWidget {
  const SchoolEventOrganisationItem({
    super.key,
    required this.organisation,
  });

  final Organisation organisation;

  @override
  Widget build(BuildContext context) {
    Image image = Image.network(
      organisation.qrCodeURL,
      fit: BoxFit.cover,
    );

    precacheImage(image.image, context);

    return ActionContainer(
      margin: const EdgeInsets.symmetric(vertical: 8),
      borderColor: Theme.of(context).colorScheme.primaryContainer,
      onTap: () {
        String generatedMediumId =
            base64.encode(organisation.namespace.codeUnits);
        context
            .read<OrganisationDetailsCubit>()
            .getOrganisationDetails(generatedMediumId);
        context.read<ScanNfcCubit>().stopScanningSession();
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvent.charityCardPressed,
          eventProperties: {
            AnalyticsHelper.charityNameKey: organisation.name,
          },
        );

        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SchoolEventOrganisationDetailBottomSheet(
            organisation: organisation,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OrganisationHeader(
              organisation: organisation,
            ),
            Container(
              height: 168,
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Image.network(
                organisation.promoPictureUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                organisation.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.recommendationItemText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
