import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class SliderWidget extends StatelessWidget {
  final double currentAmount;
  final double maxAmount;

  const SliderWidget(this.currentAmount, this.maxAmount, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 7.0,
        activeTrackColor: Theme.of(context).colorScheme.onInverseSurface,
        thumbShape: const SliderWidgetThumb(thumbRadius: 17),
        // overlayColor: Colors.black,
        // overlayShape: const RoundSliderOverlayShape(overlayRadius: 30.0),
        inactiveTrackColor: Theme.of(context).colorScheme.surfaceVariant,
        activeTickMarkColor: Theme.of(context).colorScheme.onInverseSurface,
        inactiveTickMarkColor: Theme.of(context).colorScheme.surfaceVariant,
        valueIndicatorColor: Colors.white,
        thumbColor: Theme.of(context).colorScheme.onInverseSurface,
        disabledThumbColor: AppTheme.secondary30,
      ),
      child: Slider(
        value: currentAmount,
        min: 0,
        max: maxAmount,
        divisions: maxAmount.round(),
        onChanged: (value) {
          HapticFeedback.lightImpact();

          context.read<CreateTransactionCubit>().changeAmount(value);
        },
        onChangeEnd: (value) {
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvent.amountPressed,
            eventProperties: {AnalyticsHelper.amountKey: value.roundToDouble()},
          );
        },
      ),
    );
  }
}

class SliderWidgetThumb extends SliderComponentShape {
  final double thumbRadius;

  const SliderWidgetThumb({
    required this.thumbRadius,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    // final Canvas canvas = context.canvas;
    // int sides = 4;
    // double innerPolygonRadius = thumbRadius * 1.2;
    // double outerPolygonRadius = thumbRadius * 1.4;
    // double angle = (pi * 2) / sides;

    // final outerPathColor = Paint()
    //   ..color = Colors.pink.shade800
    //   ..style = PaintingStyle.fill;

    // var outerPath = Path();

    // Offset startPoint2 = Offset(
    //   outerPolygonRadius * cos(0.0),
    //   outerPolygonRadius * sin(0.0),
    // );

    // outerPath.moveTo(
    //   startPoint2.dx + center.dx,
    //   startPoint2.dy + center.dy,
    // );

    // for (int i = 1; i <= sides; i++) {
    //   double x = outerPolygonRadius * cos(angle * i) + center.dx;
    //   double y = outerPolygonRadius * sin(angle * i) + center.dy;
    //   outerPath.lineTo(x, y);
    // }

    // outerPath.close();

    // Draw circle
    final Paint circleBluePaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    final Paint circleDarkPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Draw shadow
    context.canvas
        .drawCircle(center + const Offset(0, 2), thumbRadius, circleDarkPaint);

    context.canvas.drawCircle(center, thumbRadius, circleBluePaint);

    // Inner circle
    context.canvas.drawCircle(center, 6, circleDarkPaint);
  }
}
