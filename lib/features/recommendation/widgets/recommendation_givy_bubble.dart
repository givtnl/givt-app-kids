import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class RecommendationGivyBubble extends StatelessWidget {
  const RecommendationGivyBubble({
    required this.text,
    this.extraChild,
    this.secondaryText = '',
    super.key,
  });
  final String text;
  final Widget? extraChild;
  final String secondaryText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(64),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(
            left: 8, right: extraChild != null ? 8 : 16, top: 8, bottom: 8),
        decoration: const BoxDecoration(
          color: AppTheme.givyBubbleBackground,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/images/givy_pink_bubble.svg',
              alignment: Alignment.centerLeft,
              height: 64,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.defaultTextColor,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                ),
                if (secondaryText.isNotEmpty)
                  Text(
                    secondaryText,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.defaultTextColor,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                  ),
              ],
            ),
            const Spacer(),
            extraChild ?? const SizedBox(),
            extraChild != null ? const SizedBox(width: 8) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
