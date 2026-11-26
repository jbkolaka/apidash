import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../theme/variables.dart' hide Theme, Radius;
import '../icon/index.dart';
import '../search/index.dart';

import 'menu.props.dart';
import 'menu.styles.dart';

/// A Carbon Design System Menu widget.
///
/// Can be used as a standalone inline menu panel, or displayed as an anchored
/// floating dropdown or context menu using [CMenu.showAtPosition] or [CMenuAnchor].
/// Use [CMenu.usageSpecChart] for a Carbon-only usage/spec chart.
class CMenu extends StatefulWidget {
  const CMenu({super.key, required this.props});

  /// The configuration and entries of this menu.
  final CMenuProps props;

  @override
  State<CMenu> createState() => _CMenuState();

  /// Shows the menu as a floating modal popup anchored at [position].
  static Future<T?> showAtPosition<T>({
    required BuildContext context,
    required Offset position,
    required CMenuProps props,
  }) {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    final screenSize = overlay?.size ?? MediaQuery.of(context).size;

    final rect = RelativeRect.fromRect(
      Rect.fromLTWH(position.dx, position.dy, 0, 0),
      Offset.zero & screenSize,
    );

    return showMenu<T>(
      context: context,
      position: rect,
      elevation: props.elevation,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      items: [_PopupCMenuWrapper<T>(props: props)],
    );
  }

  /// Builds the Carbon Menu usage/spec chart from Carbon-native entries only.
  static CMenu usageSpecChart({CMenuSize size = CMenuSize.md}) {
    return CMenu(props: CMenuSpecChart.props(size: size));
  }
}

class _CMenuState extends State<CMenu> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final visibleItems = _visibleItems();

    return Container(
      constraints: BoxConstraints(
        minWidth: widget.props.minWidth,
        maxWidth: widget.props.maxWidth,
      ),
      decoration: BoxDecoration(
        color: CMenuStyles.backgroundColor(tokens),
        border: Border.all(
          color: CMenuStyles.borderColor(tokens),
          width: CMenuStyles.borderWidth,
        ),
        boxShadow: widget.props.elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.props.searchable) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                child: CSearch(
                  size: CSearchSize.sm,
                  label: widget.props.searchLabel,
                  placeholder: widget.props.searchPlaceholder,
                  autoFocus: true,
                  onChange: (value) => setState(() => _query = value),
                ),
              ),
            ],
            if (visibleItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CMenuStyles.horizontalPadding,
                  vertical: CMenuStyles.dividerMargin,
                ),
                child: Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: CMenuStyles.fontSize(widget.props.size),
                    color: tokens.textSecondary,
                  ),
                ),
              )
            else
              for (var i = 0; i < visibleItems.length; i++)
                _buildEntry(context, visibleItems[i], tokens),
          ],
        ),
      ),
    );
  }

  List<CMenuEntry> _visibleItems() {
    if (!widget.props.searchable || _query.trim().isEmpty) {
      return widget.props.items;
    }
    final query = _query.trim().toLowerCase();
    String labelOf(CMenuEntry entry) => switch (entry) {
      CMenuItem() => entry.label,
      CMenuSelectableItem() => entry.label,
      CSubmenu() => entry.label,
      CMenuDivider() => '',
      CMenuCaption() => entry.text,
      _ => '',
    };
    return widget.props.items
        .where((entry) => labelOf(entry).toLowerCase().contains(query))
        .toList();
  }

  Widget _buildEntry(
    BuildContext context,
    CMenuEntry entry,
    AppThemeTokens tokens,
  ) {
    if (entry is CMenuDivider) {
      return Container(
        height: CMenuStyles.dividerThickness,
        margin: const EdgeInsets.symmetric(vertical: CMenuStyles.dividerMargin),
        color: CMenuStyles.borderColor(tokens),
      );
    } else if (entry is CMenuCaption) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CMenuStyles.horizontalPadding,
          vertical: CMenuStyles.dividerMargin,
        ),
        child: Text(
          entry.text,
          style: TextStyle(
            fontSize: CMenuStyles.fontSize(widget.props.size) - 2,
            color: tokens.textSecondary,
          ),
        ),
      );
    } else if (entry is CMenuItem) {
      return _CMenuItemWidget(
        item: entry,
        size: widget.props.size,
        tokens: tokens,
        onSelect: (val) {
          widget.props.onSelect?.call(val);
          if (widget.props.closeOnSelect) {
            final nav = Navigator.maybeOf(context);
            if (nav != null && nav.canPop()) {
              nav.pop(val);
            }
          }
        },
      );
    } else if (entry is CMenuSelectableItem) {
      return _CMenuSelectableItemWidget(
        item: entry,
        size: widget.props.size,
        tokens: tokens,
        onSelect: (val) {
          widget.props.onSelect?.call(val);
        },
      );
    } else if (entry is CSubmenu) {
      return _CSubmenuWidget(
        submenu: entry,
        size: widget.props.size,
        tokens: tokens,
        onChildSelect: (val) {
          widget.props.onSelect?.call(val);
          if (widget.props.closeOnSelect) {
            final nav = Navigator.maybeOf(context);
            if (nav != null && nav.canPop()) {
              nav.pop(val);
            }
          }
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class _CMenuItemWidget extends StatefulWidget {
  const _CMenuItemWidget({
    required this.item,
    required this.size,
    required this.tokens,
    required this.onSelect,
  });

  final CMenuItem item;
  final CMenuSize size;
  final AppThemeTokens tokens;
  final ValueChanged<dynamic> onSelect;

  @override
  State<_CMenuItemWidget> createState() => _CMenuItemWidgetState();
}

class _CMenuItemWidgetState extends State<_CMenuItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDanger = widget.item.kind == CMenuItemKind.danger;
    final isDisabled = widget.item.disabled;

    Color textColor;
    if (isDisabled) {
      textColor = CMenuStyles.textDisabledColor(widget.tokens);
    } else if (isDanger) {
      textColor = CMenuStyles.dangerColor(widget.tokens);
    } else {
      textColor = CMenuStyles.textPrimaryColor(widget.tokens);
    }

    Color bgColor = Colors.transparent;
    if (!isDisabled && _isHovered) {
      bgColor = isDanger
          ? widget.tokens.supportError.withValues(alpha: 0.12)
          : CMenuStyles.hoverColor(widget.tokens);
    }

    final height = CMenuStyles.itemHeight(widget.size);
    final fontSize = CMenuStyles.fontSize(widget.size);

    return MouseRegion(
      onEnter: (_) {
        if (!isDisabled) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!isDisabled) setState(() => _isHovered = false);
      },
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isDisabled
            ? null
            : () {
                widget.item.onTap?.call();
                widget.onSelect(widget.item.value);
              },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: height,
          color: bgColor,
          padding: const EdgeInsets.symmetric(
            horizontal: CMenuStyles.horizontalPadding,
          ),
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    size: CMenuStyles.iconSize,
                    color: textColor,
                  ),
                  child: widget.item.icon!,
                ),
                const SizedBox(width: CMenuStyles.iconSpacing),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.item.shortcut != null &&
                  widget.item.shortcut!.isNotEmpty) ...[
                const SizedBox(width: CMenuStyles.trailingSpacing),
                Text(
                  widget.item.shortcut!,
                  style: TextStyle(
                    fontSize: fontSize - 2,
                    color: isDisabled
                        ? CMenuStyles.textDisabledColor(widget.tokens)
                        : CMenuStyles.textShortcutColor(widget.tokens),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
              if (widget.item.hasExternalIcon) ...[
                const SizedBox(width: CMenuStyles.trailingSpacing),
                IconTheme(
                  data: IconThemeData(
                    size: CMenuStyles.iconSize,
                    color: textColor,
                  ),
                  child: const Icon(CIcons.launch),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CMenuSelectableItemWidget extends StatefulWidget {
  const _CMenuSelectableItemWidget({
    required this.item,
    required this.size,
    required this.tokens,
    required this.onSelect,
  });

  final CMenuSelectableItem item;
  final CMenuSize size;
  final AppThemeTokens tokens;
  final ValueChanged<dynamic> onSelect;

  @override
  State<_CMenuSelectableItemWidget> createState() =>
      _CMenuSelectableItemWidgetState();
}

class _CMenuSelectableItemWidgetState
    extends State<_CMenuSelectableItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.item.disabled;
    final isSelected = widget.item.selected;

    Color textColor;
    if (isDisabled) {
      textColor = CMenuStyles.textDisabledColor(widget.tokens);
    } else {
      textColor = CMenuStyles.textPrimaryColor(widget.tokens);
    }

    Color bgColor = Colors.transparent;
    if (!isDisabled) {
      if (_isHovered) {
        bgColor = CMenuStyles.hoverColor(widget.tokens);
      } else if (isSelected) {
        bgColor = CMenuStyles.selectedColor(
          widget.tokens,
        ).withValues(alpha: 0.4);
      }
    }

    final height = CMenuStyles.itemHeight(widget.size);
    final fontSize = CMenuStyles.fontSize(widget.size);

    return MouseRegion(
      onEnter: (_) {
        if (!isDisabled) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!isDisabled) setState(() => _isHovered = false);
      },
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isDisabled
            ? null
            : () {
                widget.item.onChanged?.call(!isSelected);
                widget.onSelect(widget.item.value);
              },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: height,
          color: bgColor,
          padding: const EdgeInsets.symmetric(
            horizontal: CMenuStyles.horizontalPadding,
          ),
          child: Row(
            children: [
              SizedBox(
                width: CMenuStyles.iconSize,
                height: CMenuStyles.iconSize,
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: CMenuStyles.iconSize,
                        color: textColor,
                      )
                    : null,
              ),
              const SizedBox(width: CMenuStyles.iconSpacing),
              if (widget.item.icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    size: CMenuStyles.iconSize,
                    color: textColor,
                  ),
                  child: widget.item.icon!,
                ),
                const SizedBox(width: CMenuStyles.iconSpacing),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.item.shortcut != null &&
                  widget.item.shortcut!.isNotEmpty) ...[
                const SizedBox(width: CMenuStyles.trailingSpacing),
                Text(
                  widget.item.shortcut!,
                  style: TextStyle(
                    fontSize: fontSize - 2,
                    color: isDisabled
                        ? CMenuStyles.textDisabledColor(widget.tokens)
                        : CMenuStyles.textShortcutColor(widget.tokens),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CSubmenuWidget extends StatefulWidget {
  const _CSubmenuWidget({
    required this.submenu,
    required this.size,
    required this.tokens,
    required this.onChildSelect,
  });

  final CSubmenu submenu;
  final CMenuSize size;
  final AppThemeTokens tokens;
  final ValueChanged<dynamic> onChildSelect;

  @override
  State<_CSubmenuWidget> createState() => _CSubmenuWidgetState();
}

class _CSubmenuWidgetState extends State<_CSubmenuWidget> {
  bool _isHovered = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  int _transitionVersion = 0;

  void _afterFrame(VoidCallback action) {
    if (!mounted) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) action();
    });
    SchedulerBinding.instance.scheduleFrame();
  }

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    _afterFrame(() {
      if (mounted && _isHovered != value) {
        setState(() => _isHovered = value);
      }
    });
  }

  void _showSubmenu() {
    if (_overlayEntry != null || widget.submenu.disabled || !mounted) return;
    final version = ++_transitionVersion;

    _afterFrame(() {
      if (!mounted || version != _transitionVersion || _overlayEntry != null) {
        return;
      }
      final entry = OverlayEntry(
        builder: (context) {
          return Positioned(
            width: 200,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(196, 0),
              child: Material(
                type: MaterialType.transparency,
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: CMenuStyles.textPrimaryColor(widget.tokens),
                    fontSize: CMenuStyles.fontSize(widget.size),
                  ),
                  child: MouseRegion(
                    onEnter: (_) {
                      _transitionVersion++;
                      _setHovered(true);
                    },
                    onExit: (_) =>
                        _scheduleHide(const Duration(milliseconds: 100)),
                    child: CMenu(
                      props: CMenuProps(
                        items: widget.submenu.items,
                        size: widget.size,
                        onSelect: (val) {
                          _hideSubmenu();
                          widget.onChildSelect(val);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
      _overlayEntry = entry;
      Overlay.of(context).insert(entry);
    });
  }

  void _hideSubmenu() {
    final version = ++_transitionVersion;
    _afterFrame(() {
      if (!mounted || version != _transitionVersion) return;
      final entry = _overlayEntry;
      _overlayEntry = null;
      if (entry != null && entry.mounted) {
        entry.remove();
      }
      if (_isHovered) {
        setState(() => _isHovered = false);
      }
    });
  }

  void _scheduleHide(Duration delay) {
    final version = ++_transitionVersion;
    Future.delayed(delay, () {
      if (!mounted || version != _transitionVersion) return;
      _hideSubmenu();
    });
  }

  @override
  void dispose() {
    _transitionVersion++;
    final entry = _overlayEntry;
    _overlayEntry = null;
    if (entry != null && entry.mounted) {
      entry.remove();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.submenu.disabled;

    final textColor = isDisabled
        ? CMenuStyles.textDisabledColor(widget.tokens)
        : CMenuStyles.textPrimaryColor(widget.tokens);

    final bgColor = (!isDisabled && _isHovered)
        ? CMenuStyles.hoverColor(widget.tokens)
        : Colors.transparent;

    final height = CMenuStyles.itemHeight(widget.size);
    final fontSize = CMenuStyles.fontSize(widget.size);

    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          if (!isDisabled) {
            _setHovered(true);
            _showSubmenu();
          }
        },
        onExit: (_) {
          if (!isDisabled) {
            _setHovered(false);
            _scheduleHide(const Duration(milliseconds: 100));
          }
        },
        cursor: isDisabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: isDisabled ? null : _showSubmenu,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: height,
            color: bgColor,
            padding: const EdgeInsets.symmetric(
              horizontal: CMenuStyles.horizontalPadding,
            ),
            child: Row(
              children: [
                if (widget.submenu.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      size: CMenuStyles.iconSize,
                      color: textColor,
                    ),
                    child: widget.submenu.icon!,
                  ),
                  const SizedBox(width: CMenuStyles.iconSpacing),
                ],
                Expanded(
                  child: Text(
                    widget.submenu.label,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: textColor,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: CMenuStyles.caretSize,
                  color: textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// An interactive wrapper widget that anchors a [CMenu] to any target trigger.
class CMenuAnchor extends StatelessWidget {
  const CMenuAnchor({super.key, required this.props, required this.builder});

  /// Menu properties.
  final CMenuProps props;

  /// Trigger builder taking context and an `openMenu` callback.
  final Widget Function(BuildContext context, VoidCallback openMenu) builder;

  void _open(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset(0, renderBox.size.height));
    CMenu.showAtPosition(context: context, position: position, props: props);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) => builder(ctx, () => _open(ctx)));
  }
}

class _PopupCMenuWrapper<T> extends PopupMenuEntry<T> {
  const _PopupCMenuWrapper({required this.props});

  final CMenuProps props;

  @override
  double get height => 10.0;

  @override
  bool represents(T? value) => false;

  @override
  State<_PopupCMenuWrapper<T>> createState() => _PopupCMenuWrapperState<T>();
}

class _PopupCMenuWrapperState<T> extends State<_PopupCMenuWrapper<T>> {
  @override
  Widget build(BuildContext context) {
    return CMenu(props: widget.props);
  }
}
