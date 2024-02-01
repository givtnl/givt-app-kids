import 'package:flutter/material.dart';

class TextStylesColumn extends StatelessWidget {
  const TextStylesColumn({super.key});

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
          Text(
            'Display Large - Rouna Bold 57/1.2',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                // 57  is flutter default
                // fontSize: 57
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Display Medium - Rouna Bold 45/1.2 ',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                // 45  is flutter default
                // fontSize: 45
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Display Small - Rouna Bold 36/1.2',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                // 36  is flutter default
                // fontSize: 36
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Headline Large - Rouna Bold 32/1.2',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                // 32  is flutter default
                //fontSize: 32,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Headline Medium - Rouna Bold 28/1.2',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                // 28  is  set in the app theme
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Headline Small- Rouna Bold 24/1.2',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                // 24  is flutter default
                //fontSize: 24,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Title Large - Rouna Bold 26/1.2',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                // 26  is set in the app theme,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Title Medium - Rouna Bold 22/1.2',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  // 16  is flutter default
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Title Small - Rouna Bold 18/1.2',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  // 14  is flutter default
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Label Large - Rouna Bold 24/1',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                // 14  is flutter default
                fontSize: 24,
                height: 1),
          ),
          const SizedBox(height: 24),
          Text('Label Medium - Rouna Bold 20/1',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    // 14  is flutter default
                    // fontSize 20 is set in the apptheme,
                    height: 1,
                  )),
          const SizedBox(height: 24),
          Text(
            'Label Small - Rouna Bold 16/1',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  // 12  is flutter default
                  // fontSize 16 is set in the apptheme,
                  height: 1,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Body Large - Rouna Regular 22/1.4',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  // 16  is flutter default
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Body Medium - Rouna Regular 18/1.4',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  // 14  is flutter default
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Body Small - Rouna Regular 15/1.4',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // 12  is flutter default
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
