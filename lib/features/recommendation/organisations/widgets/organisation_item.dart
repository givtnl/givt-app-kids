import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app_kids/features/recommendation/organisations/widgets/organisation_detail_bottomsheet.dart';
import 'package:givt_app_kids/features/recommendation/organisations/widgets/organisation_header.dart';

class OrganisationItem extends StatelessWidget {
  const OrganisationItem({
    super.key,
    required this.width,
    required this.height,
    required this.organisation,
  });

  final double width;
  final double height;
  final Organisation organisation;

  @override
  Widget build(BuildContext context) {
    Image image = Image.network(
      organisation.qrCodeURL,
      fit: BoxFit.cover,
    );

    precacheImage(image.image, context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              String generatedMediumId =
                  base64.encode(organisation.namespace.codeUnits);
              context
                  .read<OrganisationDetailsCubit>()
                  .getOrganisationDetails(generatedMediumId);

              context.read<FlowsCubit>().startRecommendationFlow();

              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                builder: (context) => OrganisationDetailBottomSheet(
                  width: width,
                  height: height,
                  organisation: organisation,
                ),
              );
            },
            borderRadius: BorderRadius.circular(25),
            child: Card(
              elevation: 5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .3,
                      child: OrganisationHeader(
                        organisation: organisation,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: height * .55,
                          child: Image.network(
                            organisation.promoPictureUrl,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: height * .12,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            organisation.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
