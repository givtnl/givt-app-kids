import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    required this.location,
    required this.width,
    this.isSelected = false,
    this.onPressed,
    super.key,
  });

  final Tag location;
  final void Function()? onPressed;
  final double width;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: width * 1.055,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor:
              isSelected ? AppTheme.recommendationItemSelected : Colors.white,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: SizedBox.square(
                    dimension: 80,
                    child: SvgPicture.network(location.pictureUrl),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  location.displayText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.recommendationItemText,
                        fontWeight: FontWeight.w600,
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
