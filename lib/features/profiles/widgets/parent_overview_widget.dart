import 'package:firebase_remote_config/firebase_remote_config.dart';
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
    return Column(
      children: [
        // Example of using Firebase Remote Config
        // Will only show if the feature is enabled in the Firebase console,
        // by default it's disabled
        if (FirebaseRemoteConfig.instance.getBool('example_feature_enabled'))
          Text(
            'Firebase config works and is enabled 🎉',
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontSize: 12,
                ),
          ),
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
        Text(
          'Parents',
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Theme.of(context).colorScheme.outline),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: _padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: profiles
                .map(
                  (profile) => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SvgPicture.network(
                        profile.pictureURL,
                        width: 64,
                        height: 64,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
