import 'package:flutter/material.dart';

import '../../../core/carbon.dart';

/// Postman-style application header rendered with Carbon shell components.
class WorkSpaceHeader extends StatelessWidget {
  const WorkSpaceHeader({
    super.key,
    required this.environment,
    required this.environments,
    required this.onEnvironmentChanged,
    this.onBack,
  });

  final String? environment;
  final List<String> environments;
  final ValueChanged<String?> onEnvironmentChanged;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        final veryCompact = constraints.maxWidth < 900;

        final trailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!veryCompact) ...[
              _WorkspaceChip(tokens: tokens),
              const SizedBox(width: Spacing.v8px05remSpacing03),
            ],
            if (!compact) ...[
              SizedBox(
                width: 180,
                child: CSearch(
                  size: CSearchSize.sm,
                  placeholder: 'Search (Ctrl+K)',
                ),
              ),
              const SizedBox(width: Spacing.v8px05remSpacing03),
            ],
            SizedBox(
              width: veryCompact ? 116 : 132,
              child: CSelect<String>(
                size: CSelectSize.sm,
                hideLabel: true,
                placeholder: 'No Environment',
                value: environment,
                items: [
                  const CSelectItem<String>(
                    value: 'No Environment',
                    label: 'No Environment',
                  ),
                  for (final name in environments)
                    CSelectItem<String>(value: name, label: name),
                ],
                onChanged: (value) {
                  if (value != null) {
                    onEnvironmentChanged(
                      value == 'No Environment' ? null : value,
                    );
                  }
                },
              ),
            ),
          ],
        );

        return CUiShellHeader(
          props: CUiShellHeaderProps(
            title: 'Postman',
            prefix: 'API Dash',
            showMenuButton: false,
            height: Spacing.v48px3remSpacing09,
            trailing: trailing,
            actions: [
              if (onBack != null)
                CUiShellHeaderAction(
                  label: 'Back to home',
                  icon: CIcons.arrowLeft,
                  onPressed: onBack,
                ),
              const CUiShellHeaderAction(
                label: 'Settings',
                icon: CIcons.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WorkspaceChip extends StatelessWidget {
  const _WorkspaceChip({required this.tokens});

  final AppThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.v8px05remSpacing03,
      ),
      decoration: BoxDecoration(
        color: tokens.layer02,
        border: Border.all(color: tokens.borderSubtle01),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CIcons.building, size: 14, color: tokens.iconSecondary),
          const SizedBox(width: Spacing.v4px025remSpacing02),
          Text(
            'My Workspace',
            style: TypeScale.bodyCompact01.copyWith(color: tokens.textPrimary),
          ),
          const SizedBox(width: Spacing.v2px0125remSpacing01),
          Icon(CIcons.chevronDown, size: 14, color: tokens.iconSecondary),
        ],
      ),
    );
  }
}
