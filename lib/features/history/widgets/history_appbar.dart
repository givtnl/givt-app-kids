import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';
import 'package:go_router/go_router.dart';

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
      leading: IconButton(
        icon: SvgPicture.asset('assets/images/back_btn.svg'),
        color: const Color(0xFF3B3240),
        onPressed: () => context.goNamed(Pages.wallet.name),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
