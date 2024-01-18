import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';

class ParentOverviewWidget extends StatelessWidget {
  const ParentOverviewWidget({
    required this.profiles,
    super.key,
  });

  final List<Profile> profiles;

  static const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: profiles
            .map(
              (profile) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SvgPicture.network(
                  profile.pictureURL,
                  width: 48,
                  height: 48,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
