import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class GivtBackButtonFlat extends StatelessWidget {
  const GivtBackButtonFlat({
    super.key,
    this.onPressedExt,
  });

  final void Function()? onPressedExt;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const FaIcon(FontAwesomeIcons.arrowLeft),
      onPressed: () {
        SystemSound.play(SystemSoundType.click);
        onPressedExt?.call();
        context.pop();
      },
    );
  }
}
