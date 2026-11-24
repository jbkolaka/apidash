import 'package:flutter/material.dart';

import '../../../core/carbon.dart';
import 'work_space_model.dart';
import 'work_space_tooltip_label.dart';

/// Horizontal bar of open request tabs.
class WorkSpaceTabsBar extends StatelessWidget {
  const WorkSpaceTabsBar({
    super.key,
    required this.requests,
    required this.activeIndex,
    required this.onSelected,
    required this.onClosed,
    required this.onAdded,
  });

  final List<WorkspaceRequest> requests;
  final int activeIndex;
  final ValueChanged<int> onSelected;
  final ValueChanged<int> onClosed;
  final VoidCallback onAdded;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      height: Spacing.v40px25remSpacing08,
      decoration: BoxDecoration(
        color: tokens.background,
        border: Border(bottom: BorderSide(color: tokens.borderSubtle01)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                final active = index == activeIndex;
                final methodColor = workspaceMethodColor(
                  request.method,
                  tokens,
                );

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelected(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.v12px075remSpacing04,
                      ),
                      decoration: BoxDecoration(
                        color: active ? tokens.layer01 : tokens.background,
                        border: Border(
                          right: BorderSide(color: tokens.borderSubtle01),
                          top: BorderSide(
                            color: active
                                ? tokens.borderInteractive
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            request.method,
                            style: TypeScale.label01.copyWith(
                              color: methodColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: Spacing.v8px05remSpacing03),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 140),
                            child: Text(
                              request.name,
                              overflow: TextOverflow.ellipsis,
                              style: TypeScale.bodyCompact01.copyWith(
                                color: active
                                    ? tokens.textPrimary
                                    : tokens.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: Spacing.v8px05remSpacing03),
                          WorkSpaceTooltipLabel(
                            label: 'Close request',
                            child: InkWell(
                              onTap: () => onClosed(index),
                              child: Icon(
                                CIcons.close,
                                size: 14,
                                color: tokens.iconSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          WorkSpaceTooltipLabel(
            label: 'New Request',
            child: SizedBox(
              width: 16,
              height: 16,
              child: InkWell(
                onTap: onAdded,
                child: Icon(CIcons.add, size: 16, color: tokens.iconSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
