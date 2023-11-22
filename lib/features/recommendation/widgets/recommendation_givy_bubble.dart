import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      borderRadius: BorderRadius.circular(height * 0.4),
      child: Container(
        width: size.width * 0.9,
        decoration: const BoxDecoration(
          color: Color.fromARGB(200, 226, 241, 246),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(height * 0.015),
              child: SvgPicture.asset(
                'assets/images/givy_pink_bubble.svg',
                alignment: Alignment.centerLeft,
                height: height * 0.12,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: height * 0.01, vertical: 0),
                child: Text(
                  text,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Color(0xFF405A66),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
