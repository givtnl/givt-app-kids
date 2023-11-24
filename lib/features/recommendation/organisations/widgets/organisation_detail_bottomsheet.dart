import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app_kids/features/recommendation/organisations/widgets/organisation_header.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';
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
                padding: const EdgeInsets.only(right: 16),
                icon: SvgPicture.asset(
                  'assets/images/close_icon.svg',
                  alignment: Alignment.centerRight,
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: height * .35),
                padding: const EdgeInsets.only(right: 20),
                child: OrganisationHeader(
                  organisation: organisation,
                  height: height,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height * .55,
                      width: double.maxFinite,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: Image.network(
                        organisation.promoPictureUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      organisation.name,
                      textAlign: TextAlign.start,
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      organisation.shortDescription,
                      textAlign: TextAlign.start,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      organisation.longDescription,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 12),
                    Text("Even \$1 helps!",
                        textAlign: TextAlign.start,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.givt4KidsBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActoinButton(
            text: "Donate",
            onPressed: () {
              context.pushNamed(Pages.chooseAmountSlider.name);
            },
          ),
        ),
      ),
    );
  }
}
