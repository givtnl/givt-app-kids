import 'package:countup/countup.dart';
import 'package:flutter/material.dart';

class PendingApprovalWidget extends StatelessWidget {
  const PendingApprovalWidget({
    required this.pending,
    this.difference = 0,
    super.key,
  });

  final double pending;
  final double difference;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity',
          style: TextStyle(
            color: Color(0xFF3B3240),
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: const BoxDecoration(
            color: Color(0xFFB4D7FA),
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pending approval:',
                style: TextStyle(
                  color: Color(0xFF3B3240),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Countup(
                prefix: '-\$',
                begin: pending + difference,
                precision: 1,
                duration: const Duration(seconds: 3),
                end: pending,
                style: const TextStyle(
                  color: Color(0xFF3B3240),
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
