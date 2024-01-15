import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class InterestCard extends StatelessWidget {
  const InterestCard({
    required this.interest,
    required this.picture,
    required this.onPressed,
    this.isSelected = false,
    super.key,
  });

  final Tag interest;
  final SvgPicture picture;
  final void Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected ? AppTheme.recommendationItemSelected : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Radio(
                activeColor: AppTheme.interestCardRadio,
                value: isSelected ? 1 : 0,
                groupValue: 1,
                toggleable: true,
                onChanged: (_) => onPressed(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: picture,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        interest.displayText,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.recommendationItemText,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  fontSize: 16,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
