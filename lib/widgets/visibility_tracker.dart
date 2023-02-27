import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import 'package:visibility_detector/visibility_detector.dart';

class VisibilityTracker extends StatefulWidget {
  const VisibilityTracker({
    super.key,
    required this.child,
    this.observer = const _InnerVisibilityObserver(),
  });

  final Widget child;
  final VisibilityObserver observer;

  @override
  State<VisibilityTracker> createState() => _VisibilityTrackerState();
}

enum Visibility {
  visible,
  invisible;
}

mixin VisibilityObserver {
  void onChanged(Visibility visibility);
}

class _InnerVisibilityObserver with VisibilityObserver {
  const _InnerVisibilityObserver();
  @override
  void onChanged(Visibility visibility) {
    dev.log("Visibility changed to $visibility");
  }
}

class _VisibilityTrackerState extends State<VisibilityTracker>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    dev.log("AppLifecycleState: $state");
    if (state == AppLifecycleState.paused) {
      _callListener(Visibility.invisible);
    } else if (state == AppLifecycleState.resumed) {
      _callListener(Visibility.visible);
    }
  }

  void _callListener(Visibility visibility) =>
      widget.observer.onChanged(visibility);

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('VisibilityTracker'),
      onVisibilityChanged: (visibilityInfo) {
        dev.log("VisibilityDetector: $visibilityInfo");
        _callListener(
          visibilityInfo.visibleFraction == 1
              ? Visibility.visible
              : Visibility.invisible,
        );
      },
      child: widget.child,
    );
  }
}
