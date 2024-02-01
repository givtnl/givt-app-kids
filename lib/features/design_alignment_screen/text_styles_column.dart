import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TextStylesColumn extends StatelessWidget {
  const TextStylesColumn({this.scalePixels = false, super.key});
  final bool scalePixels;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Text(
          //   'Display Large - Rouna Bold 57/1.2',
          //   style: Theme.of(context).textTheme.displayLarge?.copyWith(
          //         // 57  is flutter default
          //         fontSize: scalePixels ? 57.sp : 57,
          //       ),
          // ),
          // const SizedBox(height: 24),
          // Text(
          //   'Display Medium - Rouna Bold 45/1.2 ',
          //   style: Theme.of(context).textTheme.displayMedium?.copyWith(
          //         // 45  is flutter default
          //         fontSize: scalePixels ? 45.sp : 45,
          //       ),
          // ),
          // const SizedBox(height: 24),
          Text(
            'Display Small - Rouna Bold 36/1.2',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  // 36  is flutter default
                  fontSize: scalePixels ? 36.sp : 36,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Headline Large - Rouna Bold 32/1.2',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  // 32  is flutter default
                  fontSize: scalePixels ? 32.sp : 32,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Headline Medium - Rouna Bold 28/1.2',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  // 28  is  set in the app theme
                  fontSize: scalePixels ? 28.sp : 28,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Headline Small- Rouna Bold 24/1.2',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  // 24  is flutter default
                  fontSize: scalePixels ? 24.sp : 24,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Title Large - Rouna Bold 26/1.2',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  // 26  is set in the app theme,
                  fontSize: scalePixels ? 26.sp : 26,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Title Medium - Rouna Bold 22/1.2',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  // 16  is flutter default
                  fontSize: scalePixels ? 22.px : 22,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Title Small - Rouna Bold 18/1.2',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  // 14  is flutter default
                  fontSize: scalePixels ? 18.sp : 18,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Label Large - Rouna Bold 24/1',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                // 14  is flutter default
                fontSize: scalePixels ? 24.sp : 24,
                height: 1),
          ),
          const SizedBox(height: 24),
          Text('Label Medium - Rouna Bold 20/1',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    // 14  is flutter default
                    // fontSize 20 is set in the apptheme,
                    fontSize: scalePixels ? 20.sp : 20,
                    height: 1,
                  )),
          const SizedBox(height: 24),
          Text(
            'Label Small - Rouna Bold 16/1',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  // 12  is flutter default
                  // fontSize 16 is set in the apptheme,
                  fontSize: scalePixels ? 16.sp : 16,
                  height: 1,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Body Large - Rouna Regular 22/1.4',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  // 16  is flutter default
                  fontSize: scalePixels ? 22.sp : 22,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Body Medium - Rouna Regular 18/1.4',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  // 14  is flutter default
                  fontSize: scalePixels ? 18.sp : 18,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Body Small - Rouna Regular 15/1.4',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // 12  is flutter default
                  fontSize: scalePixels ? 15.sp : 15,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
