import 'package:flutter/material.dart';

import 'package:givt_app_kids/features/recommendation/interests/cubit/interests_cubit.dart';

class InterestsTally extends StatelessWidget {
  const InterestsTally({
    required this.size,
    required this.tally,
    super.key,
  });

  final double size;
  final int tally;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(size * 0.01),
      padding: EdgeInsets.fromLTRB(
          size * 0.01, size * 0.003, size * 0.01, size * 0.004),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.1),
        color: const Color(0xFF54A1EE),
      ),
      child: Text(
        '$tally/${InterestsState.maxInterests}',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
          fontSize: size * 0.025,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
