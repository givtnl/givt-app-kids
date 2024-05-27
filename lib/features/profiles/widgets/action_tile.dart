import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/assets/tokens/tokens.g.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/action_container.dart';

class ActionTile extends StatefulWidget {
  const ActionTile({
    super.key,
    required this.onTap,
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
    required this.iconPath,
    required this.isDisabled,
    this.isSelected = false,
    this.titleBig = '',
    this.titleSmall = '',
    this.subtitle = '',
  });
  final VoidCallback onTap;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final String iconPath;
  final bool isDisabled;
  final bool isSelected;
  final String titleBig;
  final String titleSmall;
  final String subtitle;

  @override
  State<ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<ActionTile> {
  late Color backgroundColor;
  late Color borderColor;

  @override
  Widget build(BuildContext context) {
    backgroundColor = widget.backgroundColor;
    borderColor = widget.borderColor;
    final bool isOnlineIcon = widget.iconPath.contains('http');

    if (widget.isDisabled) {
      backgroundColor = AppTheme.disabledTileBackground;
      borderColor = AppTheme.disabledTileBorder;
    }
    return ActionContainer(
      isDisabled: widget.isDisabled,
      isSelected: widget.isSelected,
      borderColor: borderColor,
      onTap: widget.isDisabled ? () {} : () => widget.onTap(),
      child: Stack(
        children: [
          Container(
            color: backgroundColor,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Opacity(
                  opacity: widget.isDisabled ? 0.5 : 1,
                  child: isOnlineIcon
                      ? SvgPicture.network(
                          widget.iconPath,
                          height: 140,
                          width: 140,
                        )
                      : SvgPicture.asset(
                          widget.iconPath,
                          height: 140,
                          width: 140,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
                  child: Column(
                    children: [
                      widget.titleBig.isNotEmpty
                          ? Text(widget.titleBig,
                              textAlign: TextAlign.center,
                              style: context.tokens.textStyle.labelMedium)
                          : const SizedBox(),
                      widget.titleSmall.isNotEmpty
                          ? Text(
                              widget.titleSmall,
                              textAlign: TextAlign.center,
                              style: context.tokens.textStyle.labelSmall,
                            )
                          : const SizedBox(),
                      SizedBox(height: widget.subtitle.isNotEmpty ? 8 : 0),
                      widget.subtitle.isNotEmpty
                          ? Text(
                              widget.subtitle,
                              textAlign: TextAlign.center,
                              style: context.tokens.textStyle.labelSmall,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.isSelected)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppTheme.primary70,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
