import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app_kids/features/recommendation/organisations/widgets/organisation_header.dart';

class OrganisationDetailBottomSheet extends StatelessWidget {
  const OrganisationDetailBottomSheet({
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
    return FractionallySizedBox(
      heightFactor: 0.95,
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
    );
  }
}
