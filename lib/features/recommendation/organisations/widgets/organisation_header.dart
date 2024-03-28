import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/recommendation/organisations/models/organisation.dart';

class OrganisationHeader extends StatelessWidget {
  const OrganisationHeader({
    required this.organisation,
    super.key,
  });

  final Organisation organisation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: organisation.tags
                  .take(3)
                  .map(
                    (tag) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: tag.area.backgroundColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 20,
                        ),
                        child: Text(
                          tag.displayText,
                          style: TextStyle(
                            color: tag.area.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              constraints: BoxConstraints(
                maxHeight: organisation.tags.length * 25.0,
              ),
              child: Image.network(
                organisation.organisationLogoURL,
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
