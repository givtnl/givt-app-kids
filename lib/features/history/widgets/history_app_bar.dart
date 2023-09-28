import 'package:flutter/material.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';
import 'package:givt_app_kids/shared/widgets/back_button.dart'
    as custom_widgets;

class HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HistoryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFEEEDE4),
      elevation: 0,
      title: const Row(
        children: [
          Heading2(text: 'My Givts'),
          Spacer(),
        ],
      ),
      leading: const custom_widgets.BackButton(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
