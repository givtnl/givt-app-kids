import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button_flat.dart';

class CharityFinderAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CharityFinderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GivtBackButtonFlat(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.onPrimary,
      ),
      title: Text(
        'Charity Finder',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
