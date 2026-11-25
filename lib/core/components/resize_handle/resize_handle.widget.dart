import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/variables.dart' hide Theme, Radius;
import 'resize_handle.styles.dart';

/// Direction a resize handle can be dragged in.
enum CResizeHandleDirection {
  /// Vertical divider dragged left/right to change a panel width.
  horizontal,

  /// Horizontal divider dragged up/down to change a panel height.
  vertical,
}

/// Thin draggable divider used to resize adjacent panels.
class CResizeHandle extends StatefulWidget {
  const CResizeHandle({
    super.key,
    required this.direction,
    required this.onDrag,
    this.semanticLabel = 'Resize panel',
  });

  final CResizeHandleDirection direction;
  final ValueChanged<double> onDrag;
  final String semanticLabel;

  @override
  State<CResizeHandle> createState() => _CResizeHandleState();
}

class _CResizeHandleState extends State<CResizeHandle> {
  bool _hovering = false;

  bool get _isHorizontal =>
      widget.direction == CResizeHandleDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final lineColor = _hovering ? tokens.focus : tokens.borderSubtle00;

    return Semantics(
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: _isHorizontal
            ? SystemMouseCursors.resizeLeftRight
            : SystemMouseCursors.resizeUpDown,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: Focus(
          onKeyEvent: (node, event) {
            if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
              return KeyEventResult.ignored;
            }
            final delta = _keyboardDelta(event.logicalKey);
            if (delta == 0) return KeyEventResult.ignored;
            widget.onDrag(delta);
            return KeyEventResult.handled;
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: _isHorizontal
                ? (details) => widget.onDrag(details.delta.dx)
                : null,
            onVerticalDragUpdate: _isHorizontal
                ? null
                : (details) => widget.onDrag(details.delta.dy),
            child: SizedBox(
              width: _isHorizontal ? CResizeHandleStyles.hitThickness : null,
              height: _isHorizontal ? null : CResizeHandleStyles.hitThickness,
              child: Center(
                child: Container(
                  width: _isHorizontal
                      ? CResizeHandleStyles.lineThickness
                      : double.infinity,
                  height: _isHorizontal
                      ? double.infinity
                      : CResizeHandleStyles.lineThickness,
                  color: lineColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _keyboardDelta(LogicalKeyboardKey key) {
    final step = CResizeHandleStyles.keyboardStep;
    if (_isHorizontal) {
      if (key == LogicalKeyboardKey.arrowLeft) return -step;
      if (key == LogicalKeyboardKey.arrowRight) return step;
    } else {
      if (key == LogicalKeyboardKey.arrowUp) return -step;
      if (key == LogicalKeyboardKey.arrowDown) return step;
    }
    return 0;
  }
}
