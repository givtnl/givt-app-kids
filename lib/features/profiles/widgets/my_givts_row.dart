import 'package:flutter/material.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:go_router/go_router.dart';

class MyGivtsRow extends StatelessWidget {
  const MyGivtsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('My givts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        TextButton(
            onPressed: () => context.pushNamed(Pages.history.name),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 0)),
            ),
            child: const Text(
              'See all',
              style: TextStyle(
                color: Color(0xFF3B3240),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ))
      ],
    );
  }
}
