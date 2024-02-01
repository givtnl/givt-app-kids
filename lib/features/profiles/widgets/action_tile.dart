import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class ActionTile extends StatefulWidget {
  const ActionTile({
    super.key,
    required this.isDisabled,
    required this.text,
    required this.iconPath,
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    this.fontSize = 20,
    this.imageSize = 140,
  });
  final String text;
  final String iconPath;
  final VoidCallback onTap;
  final bool isDisabled;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double imageSize;

  @override
  _ActionTileState createState() => _ActionTileState();
}

class _ActionTileState extends State<ActionTile> {
  double bottomBorderWidth = 6;
  double widgetHeight = 218;
  Color? backgroundColor;
  Color? borderColor;

  @override
  Widget build(BuildContext context) {
    backgroundColor = widget.backgroundColor;
    borderColor = widget.borderColor;
    if (widget.isDisabled) {
      backgroundColor = AppTheme.disabledTileBackground;
      borderColor = AppTheme.disabledTileBorder;
    }
    return Expanded(
      child: GestureDetector(
        onTap: widget.isDisabled
            ? null
            : () async {
                await Future.delayed(const Duration(milliseconds: 30));
                widget.onTap();
              },
        onTapDown: widget.isDisabled
            ? null
            : (details) {
                SystemSound.play(SystemSoundType.click);
                setState(() {
                  bottomBorderWidth = 2;
                  widgetHeight = 214;
                });
              },
        onTapCancel: widget.isDisabled
            ? null
            : () async {
                await Future.delayed(const Duration(milliseconds: 30));
                HapticFeedback.lightImpact();
                setState(() {
                  bottomBorderWidth = 6;
                  widgetHeight = 218;
                });
              },
        onTapUp: widget.isDisabled
            ? null
            : (details) async {
                await Future.delayed(const Duration(milliseconds: 30));
                HapticFeedback.lightImpact();
                setState(() {
                  bottomBorderWidth = 6;
                  widgetHeight = 218;
                });
              },
        child: Container(
          decoration: BoxDecoration(
            color: borderColor!,
            border: Border(
              bottom: BorderSide(color: borderColor!, width: bottomBorderWidth),
              right: BorderSide(color: borderColor!, width: 2),
              left: BorderSide(color: borderColor!, width: 2),
              top: BorderSide(color: borderColor!, width: 2),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: widgetHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Opacity(
                    opacity: widget.isDisabled ? 0.5 : 1,
                    child: SvgPicture.asset(
                      widget.iconPath,
                      height: MediaQuery.sizeOf(context).width * .35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.isDisabled
                          ? AppTheme.disabledTileBorder
                          : widget.textColor,
                      fontSize: widget.fontSize,
                      height: 0,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
