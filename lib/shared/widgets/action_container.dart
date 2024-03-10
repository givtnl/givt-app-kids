import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class ActionContainer extends StatefulWidget {
  const ActionContainer({
    super.key,
    this.isDisabled = false,
    required this.borderColor,
    required this.onTap,
    required this.child,
    this.base = ActionContainerBase.bottom,
    this.marging,
    this.borderSize = 2,
    this.baseBorderSize = 6,
  });
  final VoidCallback onTap;
  final bool isDisabled;
  final Color borderColor;
  final ActionContainerBase base;
  final Widget child;
  final EdgeInsets? marging;
  final double borderSize;
  final double baseBorderSize;

  @override
  State<ActionContainer> createState() => _ActionContainerState();
}

class _ActionContainerState extends State<ActionContainer> {
  Color? borderColor;

  Future<void> _actionDelay() async {
    await Future.delayed(const Duration(milliseconds: 30));
  }

  bool _isManualPressed = false;

  bool get _isPressed {
    return _isManualPressed || widget.isDisabled;
  }

  void _setManualPressed(bool value) {
    setState(() {
      _isManualPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    borderColor =
        widget.isDisabled ? AppTheme.disabledTileBorder : widget.borderColor;
    return Expanded(
      child: widget.isDisabled
          ? _buildContainer(widget.child)
          : GestureDetector(
              onTap: () async {
                await _actionDelay();
                widget.onTap();
              },
              onTapDown: (details) {
                SystemSound.play(SystemSoundType.click);
                _setManualPressed(true);
              },
              onTapCancel: () async {
                await _actionDelay();
                HapticFeedback.lightImpact();
                _setManualPressed(false);
              },
              onTapUp: (details) async {
                await _actionDelay();
                HapticFeedback.lightImpact();
                _setManualPressed(false);
              },
              child: _buildContainer(widget.child),
            ),
    );
  }

  EdgeInsets? _getOpositeMarginByBase(ActionContainerBase base) {
    if (!_isPressed) {
      return null;
    }
    final opositeMargin = widget.baseBorderSize - widget.borderSize;
    switch (base) {
      case ActionContainerBase.left:
        return EdgeInsets.only(right: opositeMargin);
      case ActionContainerBase.top:
        return EdgeInsets.only(bottom: opositeMargin);
      case ActionContainerBase.right:
        return EdgeInsets.only(left: opositeMargin);
      case ActionContainerBase.bottom:
        return EdgeInsets.only(top: opositeMargin);
      case ActionContainerBase.leftTop:
        return EdgeInsets.only(
          right: opositeMargin,
          bottom: opositeMargin,
        );
      case ActionContainerBase.rightTop:
        return EdgeInsets.only(
          left: opositeMargin,
          bottom: opositeMargin,
        );
      case ActionContainerBase.rightBottom:
        return EdgeInsets.only(
          left: opositeMargin,
          top: opositeMargin,
        );
      case ActionContainerBase.leftBottom:
        return EdgeInsets.only(
          right: opositeMargin,
          top: opositeMargin,
        );
    }
  }

  Border _getBorderByBase(ActionContainerBase base) {
    return Border(
      bottom: BorderSide(
        color: borderColor!,
        width: _isPressed || base.isNotBottom
            ? widget.borderSize
            : widget.baseBorderSize,
      ),
      right: BorderSide(
        color: borderColor!,
        width: _isPressed || base.isNotRight
            ? widget.borderSize
            : widget.baseBorderSize,
      ),
      left: BorderSide(
        color: borderColor!,
        width: _isPressed || base.isNotLeft
            ? widget.borderSize
            : widget.baseBorderSize,
      ),
      top: BorderSide(
        color: borderColor!,
        width: _isPressed || base.isNotTop
            ? widget.borderSize
            : widget.baseBorderSize,
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      margin: widget.marging,
      child: Container(
        margin: _getOpositeMarginByBase(widget.base),
        decoration: BoxDecoration(
          color: borderColor!,
          border: _getBorderByBase(widget.base),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: child,
        ),
      ),
    );
  }
}

enum ActionContainerBase {
  left,
  top,
  right,
  bottom,
  leftTop,
  rightTop,
  rightBottom,
  leftBottom;

  bool get isLeft {
    return this == left || this == leftTop || this == leftBottom;
  }

  bool get isNotLeft {
    return !isLeft;
  }

  bool get isRight {
    return this == right || this == rightTop || this == rightBottom;
  }

  bool get isNotRight {
    return !isRight;
  }

  bool get isTop {
    return this == top || this == leftTop || this == rightTop;
  }

  bool get isNotTop {
    return !isTop;
  }

  bool get isBottom {
    return this == bottom || this == leftBottom || this == rightBottom;
  }

  bool get isNotBottom {
    return !isBottom;
  }
}
