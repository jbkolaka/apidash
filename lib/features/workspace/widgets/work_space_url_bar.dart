import 'package:flutter/material.dart';

import '../../../core/carbon.dart';
import 'work_space_model.dart';

/// Method, URL, and send controls for the workbench.
class WorkSpaceUrlBar extends StatefulWidget {
  const WorkSpaceUrlBar({
    super.key,
    required this.request,
    required this.loading,
    required this.onMethodChanged,
    required this.onUrlChanged,
    required this.onSend,
    required this.onSave,
  });

  final WorkspaceRequest request;
  final bool loading;
  final ValueChanged<String> onMethodChanged;
  final ValueChanged<String> onUrlChanged;
  final VoidCallback onSend;
  final VoidCallback onSave;

  @override
  State<WorkSpaceUrlBar> createState() => _WorkSpaceUrlBarState();
}

class _WorkSpaceUrlBarState extends State<WorkSpaceUrlBar> {
  static const _methods = [
    'GET',
    'POST',
    'PUT',
    'DELETE',
    'PATCH',
    'HEAD',
    'OPTIONS',
  ];

  late final TextEditingController _controller;
  VoidCallback? _toggleMethodMenu;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.request.url);
  }

  @override
  void didUpdateWidget(covariant WorkSpaceUrlBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.request.url != _controller.text &&
        widget.request.id != oldWidget.request.id) {
      _controller.text = widget.request.url;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.v16px1remSpacing05,
        vertical: Spacing.v12px075remSpacing04,
      ),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border(bottom: BorderSide(color: tokens.borderSubtle01)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;

          return Row(
            children: [
              Expanded(
                child: Container(
                  height: Spacing.v48px3remSpacing09,
                  decoration: BoxDecoration(
                    color: tokens.field01,
                    border: Border.all(color: tokens.borderSubtle01),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: compact ? 88 : 104,
                        child: CPopover(
                          align: CPopoverAlignment.bottomStart,
                          triggerBuilder: (context, toggle, isOpen) {
                            _toggleMethodMenu = toggle;
                            return _buildMethodTrigger(tokens, isOpen, toggle);
                          },
                          content: _buildMethodMenu(tokens),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: tokens.borderSubtle01,
                      ),
                      Expanded(
                        child: CTextField(
                          hideBorder: true,
                          controller: _controller,
                          hint: 'Enter URL or paste text',
                          onChanged: widget.onUrlChanged,
                          onSubmitted: (_) => widget.onSend(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Spacing.v12px075remSpacing04),
              CButton(
                label: widget.loading ? 'Sending' : 'Send',
                size: CButtonSize.sm,
                icon: Icon(CIcons.send, size: 14, color: tokens.textOnColor),
                enable: !widget.loading,
                onTap: widget.onSend,
              ),
              // if (!compact) ...[
              //   const SizedBox(width: Spacing.v8px05remSpacing03),
              //   CButton(
              //     label: 'Save',
              //     size: CButtonSize.sm,
              //     kind: CButtonKind.secondary,
              //     onTap: widget.onSave,
              //   ),
              // ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildMethodTrigger(
    AppThemeTokens tokens,
    bool isOpen,
    VoidCallback toggle,
  ) {
    final method = widget.request.method;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: toggle,
        child: Container(
          height: Spacing.v48px3remSpacing09,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v8px05remSpacing03,
          ),
          decoration: BoxDecoration(
            color: isOpen ? tokens.layerSelected01 : tokens.field01,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  method,
                  overflow: TextOverflow.ellipsis,
                  style: TypeScale.bodyCompact01.copyWith(
                    color: workspaceMethodColor(method, tokens),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(CIcons.chevronDown, size: 14, color: tokens.iconSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodMenu(AppThemeTokens tokens) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 320),
      child: SingleChildScrollView(
        child: SizedBox(
          width: 132,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final method in _methods) _methodItem(method, tokens),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodItem(String method, AppThemeTokens tokens) {
    final selected = method == widget.request.method;

    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.onMethodChanged(method);
          _toggleMethodMenu?.call();
        },
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v8px05remSpacing03,
          ),
          decoration: BoxDecoration(
            color: selected ? tokens.layerSelected01 : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: selected ? tokens.borderInteractive : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 14,
                child: selected
                    ? Icon(
                        CIcons.checkmark,
                        size: 14,
                        color: tokens.iconPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: Spacing.v8px05remSpacing03),
              Expanded(
                child: Text(
                  method,
                  overflow: TextOverflow.ellipsis,
                  style: TypeScale.bodyCompact01.copyWith(
                    color: workspaceMethodColor(method, tokens),
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
