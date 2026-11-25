import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../theme/variables.dart' hide Theme, Radius;

import 'popover.props.dart';
import 'popover.styles.dart';

typedef _Styles = CPopoverStyles;

/// Carbon Popover component.
///
/// Anchors a floating surface adjacent to a trigger widget. Supports customizable
/// directional alignment, caret indicators, high-contrast mode, and tap-outside closing.
class CPopover extends StatefulWidget {
  CPopover({
    super.key,
    bool open = false,
    CPopoverAlignment align = CPopoverAlignment.bottom,
    bool caret = true,
    bool dropShadow = true,
    bool highContrast = false,
    bool autoAlign = true,
    bool closeOnTapOutside = true,
    bool hitTestable = true,
    double offset = 4.0,
    VoidCallback? onRequestClose,
    Widget? trigger,
    Widget? content,
    Widget Function(BuildContext context, VoidCallback toggle, bool isOpen)?
    triggerBuilder,
  }) : props = CPopoverProps(
         open: open,
         align: align,
         caret: caret,
         dropShadow: dropShadow,
         highContrast: highContrast,
         autoAlign: autoAlign,
         closeOnTapOutside: closeOnTapOutside,
         hitTestable: hitTestable,
         offset: offset,
         onRequestClose: onRequestClose,
         trigger: trigger,
         content: content,
         triggerBuilder: triggerBuilder,
       );

  final CPopoverProps props;

  @override
  State<CPopover> createState() => _CPopoverState();
}

class _CPopoverState extends State<CPopover> {
  final GlobalKey _triggerKey = GlobalKey();
  final GlobalKey _surfaceKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  Offset _anchorPoint = Offset.zero;
  Offset _surfaceOffset = Offset.zero;
  bool _internalOpen = false;

  bool get _isOpen =>
      widget.props.triggerBuilder != null ? _internalOpen : widget.props.open;

  @override
  void initState() {
    super.initState();
    _internalOpen = widget.props.open;
    if (_isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showOverlay());
    }
  }

  @override
  void didUpdateWidget(CPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.open != oldWidget.props.open) {
      _internalOpen = widget.props.open;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.props.open) {
          _showOverlay();
        } else {
          _hideOverlay();
        }
      });
    }
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _internalOpen = !_internalOpen;
    });
    if (_internalOpen) {
      _showOverlay();
    } else {
      _hideOverlay();
      widget.props.onRequestClose?.call();
    }
  }

  void _handleTapOutside() {
    if (widget.props.triggerBuilder != null) {
      setState(() {
        _internalOpen = false;
      });
    }
    _hideOverlay();
    widget.props.onRequestClose?.call();
  }

  void _handleOutsidePointerDown(PointerDownEvent event) {
    final surfaceContext = _surfaceKey.currentContext;
    if (surfaceContext != null) {
      final surface = surfaceContext.findRenderObject() as RenderBox?;
      if (surface != null &&
          surface.hitTest(
            BoxHitTestResult(),
            position: surface.globalToLocal(event.position),
          )) {
        return;
      }
    }
    _handleTapOutside();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final trigger = _triggerKey.currentContext?.findRenderObject();
    final triggerBox = trigger is RenderBox && trigger.hasSize ? trigger : null;
    final position = triggerBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final size = triggerBox?.size ?? Size.zero;
    _anchorPoint =
        _triggerAnchorPoint(widget.props.align, position, size) +
        _alignmentOffset(
          widget.props.align,
          widget.props.offset,
          widget.props.caret,
        );
    _surfaceOffset = _anchorPoint;

    final tokens = context.tokens;
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildOverlayContent(tokens),
    );
    overlay.insert(_overlayEntry!);
    WidgetsBinding.instance.addPostFrameCallback((_) => _alignSurface());
  }

  void _alignSurface() {
    if (!mounted || _overlayEntry == null) return;
    final surface = _surfaceKey.currentContext?.findRenderObject();
    if (surface is! RenderBox || !surface.hasSize) return;

    final alignment = _followerAnchor(widget.props.align);
    var left = _anchorPoint.dx - (alignment.x + 1) * surface.size.width / 2;
    var top = _anchorPoint.dy - (alignment.y + 1) * surface.size.height / 2;

    if (widget.props.autoAlign) {
      final screen = MediaQuery.maybeSizeOf(context);
      if (screen != null) {
        final maxLeft = screen.width - surface.size.width - 8;
        final maxTop = screen.height - surface.size.height - 8;
        left = left.clamp(8.0, maxLeft < 8 ? 8.0 : maxLeft);
        top = top.clamp(8.0, maxTop < 8 ? 8.0 : maxTop);
      }
    }

    final next = Offset(left, top);
    if (next != _surfaceOffset) {
      _surfaceOffset = next;
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  Offset _triggerAnchorPoint(
    CPopoverAlignment align,
    Offset position,
    Size size,
  ) {
    return switch (align) {
      CPopoverAlignment.top => Offset(
        position.dx + size.width / 2,
        position.dy,
      ),
      CPopoverAlignment.topStart => position,
      CPopoverAlignment.topEnd => Offset(position.dx + size.width, position.dy),
      CPopoverAlignment.bottom => Offset(
        position.dx + size.width / 2,
        position.dy + size.height,
      ),
      CPopoverAlignment.bottomStart => Offset(
        position.dx,
        position.dy + size.height,
      ),
      CPopoverAlignment.bottomEnd => Offset(
        position.dx + size.width,
        position.dy + size.height,
      ),
      CPopoverAlignment.left => Offset(
        position.dx,
        position.dy + size.height / 2,
      ),
      CPopoverAlignment.leftStart => position,
      CPopoverAlignment.leftEnd => Offset(
        position.dx,
        position.dy + size.height,
      ),
      CPopoverAlignment.right => Offset(
        position.dx + size.width,
        position.dy + size.height / 2,
      ),
      CPopoverAlignment.rightStart => Offset(
        position.dx + size.width,
        position.dy,
      ),
      CPopoverAlignment.rightEnd => Offset(
        position.dx + size.width,
        position.dy + size.height,
      ),
    };
  }

  Alignment _followerAnchor(CPopoverAlignment align) {
    return switch (align) {
      CPopoverAlignment.top => Alignment.bottomCenter,
      CPopoverAlignment.topStart => Alignment.bottomLeft,
      CPopoverAlignment.topEnd => Alignment.bottomRight,
      CPopoverAlignment.bottom => Alignment.topCenter,
      CPopoverAlignment.bottomStart => Alignment.topLeft,
      CPopoverAlignment.bottomEnd => Alignment.topRight,
      CPopoverAlignment.left => Alignment.centerRight,
      CPopoverAlignment.leftStart => Alignment.topRight,
      CPopoverAlignment.leftEnd => Alignment.bottomRight,
      CPopoverAlignment.right => Alignment.centerLeft,
      CPopoverAlignment.rightStart => Alignment.topLeft,
      CPopoverAlignment.rightEnd => Alignment.bottomLeft,
    };
  }

  Offset _alignmentOffset(
    CPopoverAlignment align,
    double offset,
    bool hasCaret,
  ) {
    final double extra = hasCaret ? _Styles.caretHeight : 0.0;
    final double distance = offset + extra;

    return switch (align) {
      CPopoverAlignment.top ||
      CPopoverAlignment.topStart ||
      CPopoverAlignment.topEnd => Offset(0, -distance),
      CPopoverAlignment.bottom ||
      CPopoverAlignment.bottomStart ||
      CPopoverAlignment.bottomEnd => Offset(0, distance),
      CPopoverAlignment.left ||
      CPopoverAlignment.leftStart ||
      CPopoverAlignment.leftEnd => Offset(-distance, 0),
      CPopoverAlignment.right ||
      CPopoverAlignment.rightStart ||
      CPopoverAlignment.rightEnd => Offset(distance, 0),
    };
  }

  Widget _buildOverlayContent(AppThemeTokens tokens) {
    final Color bgColor = _Styles.backgroundColor(
      tokens: tokens,
      highContrast: widget.props.highContrast,
    );
    final Color borderColor = _Styles.borderColor(
      tokens: tokens,
      highContrast: widget.props.highContrast,
    );
    final Color textColor = _Styles.textColor(
      tokens: tokens,
      highContrast: widget.props.highContrast,
    );

    return Stack(
      children: [
        if (widget.props.closeOnTapOutside)
          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: _handleOutsidePointerDown,
            ),
          ),
        Positioned(
          left: _surfaceOffset.dx,
          top: _surfaceOffset.dy,
          child: IgnorePointer(
            ignoring: !widget.props.hitTestable,
            child: ConstrainedBox(
              key: _surfaceKey,
              constraints: const BoxConstraints(maxWidth: 288),
              child: DefaultTextStyle(
                style: TextStyle(color: textColor, fontSize: 14.0),
                child: Material(
                  type: MaterialType.transparency,
                  child: _PopoverSurface(
                    align: widget.props.align,
                    caret: widget.props.caret,
                    dropShadow: widget.props.dropShadow,
                    backgroundColor: bgColor,
                    borderColor: borderColor,
                    child: Padding(
                      padding: _Styles.defaultPadding,
                      child: widget.props.content ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget triggerWidget;
    if (widget.props.triggerBuilder != null) {
      triggerWidget = widget.props.triggerBuilder!(context, _toggle, _isOpen);
    } else {
      triggerWidget = widget.props.trigger ?? const SizedBox.shrink();
    }

    return KeyedSubtree(key: _triggerKey, child: triggerWidget);
  }
}

/// Floating popover surface container with border, drop shadow, and optional caret.
class _PopoverSurface extends StatelessWidget {
  const _PopoverSurface({
    required this.align,
    required this.caret,
    required this.dropShadow,
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
  });

  final CPopoverAlignment align;
  final bool caret;
  final bool dropShadow;
  final Color backgroundColor;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Widget container = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: _Styles.borderRadius,
        border: Border.all(color: borderColor, width: _Styles.borderWidth),
        boxShadow: dropShadow ? _Styles.dropShadow() : null,
      ),
      child: child,
    );

    if (!caret) return container;

    // Stack caret tip next to container
    return CustomPaint(
      painter: _CaretPainter(
        align: align,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
      ),
      child: container,
    );
  }
}

/// Painter to draw the Carbon Popover triangular caret tip.
class _CaretPainter extends CustomPainter {
  const _CaretPainter({
    required this.align,
    required this.backgroundColor,
    required this.borderColor,
  });

  final CPopoverAlignment align;
  final Color backgroundColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = borderColor
      ..strokeWidth = _Styles.borderWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    final double w = _Styles.caretWidth;
    final double h = _Styles.caretHeight;

    switch (align) {
      case CPopoverAlignment.bottom:
      case CPopoverAlignment.bottomStart:
      case CPopoverAlignment.bottomEnd:
        // Caret points up from top of container
        final double centerX = align == CPopoverAlignment.bottomStart
            ? w
            : (align == CPopoverAlignment.bottomEnd
                  ? size.width - w
                  : size.width / 2);
        path.moveTo(centerX - w / 2, 0);
        path.lineTo(centerX, -h);
        path.lineTo(centerX + w / 2, 0);
        path.close();
      case CPopoverAlignment.top:
      case CPopoverAlignment.topStart:
      case CPopoverAlignment.topEnd:
        // Caret points down from bottom of container
        final double centerX = align == CPopoverAlignment.topStart
            ? w
            : (align == CPopoverAlignment.topEnd
                  ? size.width - w
                  : size.width / 2);
        path.moveTo(centerX - w / 2, size.height);
        path.lineTo(centerX, size.height + h);
        path.lineTo(centerX + w / 2, size.height);
        path.close();
      case CPopoverAlignment.right:
      case CPopoverAlignment.rightStart:
      case CPopoverAlignment.rightEnd:
        // Caret points left from left side of container
        final double centerY = align == CPopoverAlignment.rightStart
            ? w
            : (align == CPopoverAlignment.rightEnd
                  ? size.height - w
                  : size.height / 2);
        path.moveTo(0, centerY - w / 2);
        path.lineTo(-h, centerY);
        path.lineTo(0, centerY + w / 2);
        path.close();
      case CPopoverAlignment.left:
      case CPopoverAlignment.leftStart:
      case CPopoverAlignment.leftEnd:
        // Caret points right from right side of container
        final double centerY = align == CPopoverAlignment.leftStart
            ? w
            : (align == CPopoverAlignment.leftEnd
                  ? size.height - w
                  : size.height / 2);
        path.moveTo(size.width, centerY - w / 2);
        path.lineTo(size.width + h, centerY);
        path.lineTo(size.width, centerY + w / 2);
        path.close();
    }

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(_CaretPainter oldDelegate) {
    return align != oldDelegate.align ||
        backgroundColor != oldDelegate.backgroundColor ||
        borderColor != oldDelegate.borderColor;
  }
}

/// Standard content container wrapper for popover bodies.
class CPopoverContent extends StatelessWidget {
  const CPopoverContent({
    super.key,
    required this.child,
    this.padding = _Styles.defaultPadding,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}
