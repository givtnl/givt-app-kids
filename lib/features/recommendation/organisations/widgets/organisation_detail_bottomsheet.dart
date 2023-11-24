import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app_kids/features/recommendation/organisations/widgets/organisation_header.dart';
import 'package:go_router/go_router.dart';

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
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () => context.pop(),
                icon: SvgPicture.asset(
                  'assets/images/close_icon.svg',
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: height * .2,
                  maxHeight: height * .35,
                ),
                child: OrganisationHeader(
                  organisation: organisation,
                  height: height,
                ),
              ),
              Container(
                height: height * .55,
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Image.network(
                  organisation.promoPictureUrl,
                  fit: BoxFit.cover,
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
        ),
      ),
    );
  }
}
