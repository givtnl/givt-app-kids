import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';

class InterestCard extends StatelessWidget {
  const InterestCard({
    required this.interest,
    required this.width,
    required this.onPressed,
    this.isSelected = false,
    super.key,
  });

  final Tag interest;
  final void Function() onPressed;
  final double width;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      padding: EdgeInsets.all(width * 0.02),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 25,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.020),
            side: isSelected
                ? const BorderSide(
                    color: Color(0xFF97A486),
                    width: 2,
                  )
                : BorderSide.none,
          ),
          padding: EdgeInsets.zero,
          backgroundColor:
              isSelected ? const Color(0XFFDFF3C5) : const Color(0XFFFAF4D8),
        ),
        onPressed: onPressed,
        child: Stack(
          children: [
            Positioned(
              top: -10,
              left: -10,
              child: Radio(
                activeColor: const Color(0XFF7AAA35),
                value: isSelected ? 1 : 0,
                groupValue: 1,
                toggleable: true,
                onChanged: (_) => onPressed(),
              ),
            ),
            Positioned.fill(
              child: Row(
                children: [
                  const SizedBox(width: 25),
                  Expanded(
                    child: Text(
                      interest.displayText,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(
                          color: Color(0xFF405A66),
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: SvgPicture.network(
                        interest.pictureUrl,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
