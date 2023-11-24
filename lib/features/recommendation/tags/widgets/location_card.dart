import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    required this.location,
    required this.width,
    this.isSelected = false,
    this.onPressed,
    super.key,
  });

  final Tag location;
  final void Function()? onPressed;
  final double width;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * 1.2,
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 25,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isSelected
                ? const BorderSide(
                    color: Color(0xFF97A486),
                    width: 2,
                  )
                : BorderSide.none,
          ),
          backgroundColor:
              isSelected ? const Color(0XFFDFF3C5) : const Color(0XFFFAF4D8),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.network(location.pictureUrl, height: width * 0.45),
            SizedBox(height: width * 0.05),
            Text(
              location.displayText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF405A66),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
