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
                        child: CSelect<String>(
                          size: CSelectSize.sm,
                          hideLabel: true,
                          value: widget.request.method,
                          items: [
                            for (final method in _methods)
                              CSelectItem<String>(value: method, label: method),
                          ],
                          onChanged: (method) {
                            if (method != null) {
                              widget.onMethodChanged(method);
                            }
                          },
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: tokens.borderSubtle01,
                      ),
                      Expanded(
                        child: CTextField(
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
              if (!compact) ...[
                const SizedBox(width: Spacing.v8px05remSpacing03),
                CButton(
                  label: 'Save',
                  size: CButtonSize.sm,
                  kind: CButtonKind.secondary,
                  onTap: widget.onSave,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
