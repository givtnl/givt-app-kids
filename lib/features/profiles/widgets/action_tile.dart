import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class ActionTile extends StatefulWidget {
  const ActionTile(
      {super.key,
      required this.size,
      required this.isDisabled,
      required this.text,
      required this.iconPath,
      required this.borderColor,
      required this.backgroundColor,
      required this.textColor,
      required this.onTap});
  final Size size;
  final String text;
  final String iconPath;
  final VoidCallback onTap;
  final bool isDisabled;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  @override
  _ActionTileState createState() => _ActionTileState();
}

class _ActionTileState extends State<ActionTile> {
  double bottomBorderWidth = 10.0;
  double? widgetHeight;
  Color? backgroundColor;
  Color? borderColor;

  @override
  void initState() {
    super.initState();
    widgetHeight = widget.size.width * .5;
    backgroundColor = widget.backgroundColor;
    borderColor = widget.borderColor;
    if (widget.isDisabled) {
      backgroundColor = AppTheme.disabledTileBackground;
      borderColor = AppTheme.disabledTileBorder;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (details) {
        setState(() {
          bottomBorderWidth = 3.0;
          widgetHeight = widget.size.width * .5 - 7;
        });
      },
      onTapUp: (details) {
        setState(() {
          bottomBorderWidth = 10.0;
          widgetHeight = widget.size.width * .5;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: borderColor!,
          border: Border(
            bottom: BorderSide(color: borderColor!, width: bottomBorderWidth),
            right: BorderSide(color: borderColor!, width: 3.0),
            left: BorderSide(color: borderColor!, width: 3.0),
            top: BorderSide(color: borderColor!, width: 3.0),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        width: size.width * .5 - 32,
        height: widgetHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Opacity(
                  opacity: widget.isDisabled ? 0.5 : 1,
                  child: SvgPicture.asset(
                    widget.iconPath,
                  ),
                ),
                Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isDisabled
                        ? AppTheme.disabledTileBorder
                        : widget.textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
