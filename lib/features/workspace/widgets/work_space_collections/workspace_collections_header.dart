import 'package:flutter/material.dart';

import '../../../../core/carbon.dart';

/// Header with the icon-only view switcher and the workspace Add menu.
class WorkspaceCollectionsHeader extends StatelessWidget {
  const WorkspaceCollectionsHeader({
    super.key,
    required this.addMenuProps,
    required this.onViewChanged,
  });

  final CMenuProps addMenuProps;
  final ValueChanged<int> onViewChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.v12px075remSpacing04,
        vertical: Spacing.v8px05remSpacing03,
      ),
      child: Row(
        children: [
          Expanded(
            child: CContentSwitcher(
              props: CContentSwitcherProps(
                size: CContentSwitcherSize.sm,
                expand: false,
                showLabels: false,
                options: const [
                  CContentSwitcherOption(
                    label: 'Collections',
                    icon: Icon(CIcons.box),
                  ),
                  CContentSwitcherOption(
                    label: 'Services',
                    icon: Icon(CIcons.toolBox),
                  ),
                ],
                onSelectionChanged: onViewChanged,
              ),
            ),
          ),
          CMenuAnchor(
            props: addMenuProps,
            builder: (context, openMenu) => CButton.icon(
              kind: CButtonKind.ghost,
              size: CButtonSize.sm,
              icon: Icon(CIcons.add, size: 16, color: tokens.iconSecondary),
              onTap: openMenu,
            ),
          ),
        ],
      ),
    );
  }
}
