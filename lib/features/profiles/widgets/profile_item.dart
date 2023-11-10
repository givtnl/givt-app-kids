import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    Key? key,
    required this.name,
    required this.imageUrl,
  }) : super(key: key);

  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SvgPicture.network(
                  imageUrl,
                  width: size.width * 0.3,
                  height: size.width * 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF3B3240),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
