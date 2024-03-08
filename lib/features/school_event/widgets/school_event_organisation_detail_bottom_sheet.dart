import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app_kids/features/recommendation/organisations/widgets/organisation_header.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

class SchoolEventOrganisationDetailBottomSheet extends StatelessWidget {
  const SchoolEventOrganisationDetailBottomSheet({
    super.key,
    required this.organisation,
  });

  final double height = 100;
  final Organisation organisation;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            forceMaterialTransparency: true,
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
          body: Scrollable(
            viewportBuilder: (context, offset) => ListView(
              children: [
                OrganisationHeader(
                  organisation: organisation,
                ),
                Container(
                  height: 168,
                  width: double.maxFinite,
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Image.network(
                    organisation.promoPictureUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organisation.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.primary20,
                                ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        organisation.shortDescription,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primary20,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'About us',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primary20,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        organisation.longDescription,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primary20,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: GivtElevatedButton(
              text: "Continue",
              onTap: () {
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvent.donateToRecommendedCharityPressed,
                  eventProperties: {
                    AnalyticsHelper.charityNameKey: organisation.name,
                  },
                );
                context.pushNamed(Pages.chooseAmountSlider.name);
              },
            ),
          ),
        ),
      ),
    );
  }
}
