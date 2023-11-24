import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class RecommendationGivyBubble extends StatelessWidget {
  const RecommendationGivyBubble({
    required this.text,
    this.extraChild,
    super.key,
  });
  final String text;
  final Widget? extraChild;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height * 0.6;

    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8),
        decoration: const BoxDecoration(
          color: AppTheme.givyBubbleBackground,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/images/givy_pink_bubble.svg',
              alignment: Alignment.centerLeft,
              height: height * 0.12,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  text,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.defaultTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            extraChild ?? const SizedBox()
          ],
        ),
      ),
    );
  }
}
