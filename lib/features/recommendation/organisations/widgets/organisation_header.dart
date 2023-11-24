import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/recommendation/organisations/models/organisation.dart';

class OrganisationHeader extends StatelessWidget {
  const OrganisationHeader({
    required this.organisation,
    required this.height,
    super.key,
  });

  final Organisation organisation;
  final double height;

  @override
  Widget build(BuildContext context) {
    final iconHeight = organisation.tags.length * 30.0;
    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: organisation.tags
                .map(
                  (tag) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: tag.area.color,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 15,
                      ),
                      child: Text(
                        tag.displayText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                )
                .take(3)
                .toList(),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: iconHeight,
            ),
            child: Image.network(
              organisation.organisationLogoURL,
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}
