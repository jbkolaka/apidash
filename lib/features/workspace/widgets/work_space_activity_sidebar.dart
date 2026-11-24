import 'package:flutter/material.dart';

import '../../../core/carbon.dart';
import '../../../core/components/tooltip/tooltip.props.dart'
    as tooltip
    show CTooltipAlignment;
import 'work_space_model.dart';
import 'work_space_tooltip_label.dart';

/// Narrow activity rail matching the workbench layout.
class WorkSpaceActivitySidebar extends StatelessWidget {
  const WorkSpaceActivitySidebar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final WorkspaceSidebarSection selected;
  final ValueChanged<WorkspaceSidebarSection> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      width: Spacing.v48px3remSpacing09,
      decoration: BoxDecoration(
        color: tokens.background,
        border: Border(right: BorderSide(color: tokens.borderSubtle01)),
      ),
      child: Column(
        children: [
          const SizedBox(height: Spacing.v8px05remSpacing03),
          _SectionButton(
            label: 'Collections',
            icon: CIcons.folder,
            activeIcon: CIcons.folder,
            active: selected == WorkspaceSidebarSection.collections,
            onTap: () => onChanged(WorkspaceSidebarSection.collections),
          ),
          _SectionButton(
            label: 'History',
            icon: CIcons.time,
            activeIcon: CIcons.recentlyViewed,
            active: selected == WorkspaceSidebarSection.history,
            onTap: () => onChanged(WorkspaceSidebarSection.history),
          ),
          _SectionButton(
            label: 'Environments',
            icon: CIcons.layers,
            activeIcon: CIcons.layers,
            active: selected == WorkspaceSidebarSection.environments,
            onTap: () => onChanged(WorkspaceSidebarSection.environments),
          ),
          const Spacer(),
          WorkSpaceTooltipLabel(
            align: tooltip.CTooltipAlignment.right,
            label: 'Runner',
            child: SizedBox(
              width: 20,
              height: 20,
              child: InkWell(
                onTap: () {},
                child: Icon(
                  CIcons.tools,
                  size: 20,
                  color: tokens.iconSecondary,
                ),
              ),
            ),
          ),
          WorkSpaceTooltipLabel(
            align: tooltip.CTooltipAlignment.right,
            label: 'Help',
            child: SizedBox(
              width: 20,
              height: 20,
              child: InkWell(
                onTap: () {},
                child: Icon(CIcons.help, size: 20, color: tokens.iconSecondary),
              ),
            ),
          ),
          const SizedBox(height: Spacing.v8px05remSpacing03),
        ],
      ),
    );
  }
}

class _SectionButton extends StatelessWidget {
  const _SectionButton({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = active ? tokens.linkPrimary : tokens.iconSecondary;

    return WorkSpaceTooltipLabel(
      align: tooltip.CTooltipAlignment.right,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: Spacing.v48px3remSpacing09,
            height: Spacing.v48px3remSpacing09,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: active ? tokens.borderInteractive : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Icon(active ? activeIcon : icon, size: 22, color: color),
          ),
        ),
      ),
    );
  }
}
