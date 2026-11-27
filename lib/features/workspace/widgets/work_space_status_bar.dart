import 'package:flutter/material.dart';

import '../../../core/carbon.dart';

/// Workbench status strip with connection, environment, and version metadata.
class WorkSpaceStatusBar extends StatelessWidget {
  const WorkSpaceStatusBar({
    super.key,
    required this.environment,
    required this.port,
    required this.isCollectionsVisible,
    required this.onToggleCollections,
    required this.isResponseVisible,
    required this.onToggleResponse,
    required this.isAiShellVisible,
    required this.onToggleAiShell,
  });

  final String? environment;
  final int port;
  final bool isCollectionsVisible;
  final VoidCallback onToggleCollections;
  final bool isResponseVisible;
  final VoidCallback onToggleResponse;
  final bool isAiShellVisible;
  final VoidCallback onToggleAiShell;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      height: Spacing.v32px2remSpacing07,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.v12px075remSpacing04,
      ),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border(top: BorderSide(color: tokens.borderSubtle01)),
      ),
      child: Row(
        children: [
          _PanelToggle(
            icon: isCollectionsVisible
                ? CIcons.openPanelFilledLeft
                : CIcons.openPanelLeft,
            tooltip: isCollectionsVisible
                ? 'Hide collections panel'
                : 'Show collections panel',
            onTap: onToggleCollections,
          ),
          const SizedBox(width: Spacing.v4px025remSpacing02),
          _PanelToggle(
            icon: isResponseVisible
                ? CIcons.openPanelFilledBottom
                : CIcons.openPanelBottom,
            tooltip: isResponseVisible
                ? 'Hide response panel'
                : 'Show response panel',
            onTap: onToggleResponse,
          ),
          const SizedBox(width: Spacing.v8px05remSpacing03),
          Container(
            width: Spacing.v8px05remSpacing03,
            height: Spacing.v8px05remSpacing03,
            decoration: BoxDecoration(
              color: tokens.supportSuccess,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: Spacing.v4px025remSpacing02 + 2),
          _StatusText(label: 'Online', color: tokens.textSecondary),
          const SizedBox(width: Spacing.v12px075remSpacing04),
          _StatusText(
            label: 'Env: ${environment ?? 'None'}',
            color: tokens.textSecondary,
          ),
          const SizedBox(width: Spacing.v12px075remSpacing04),
          _StatusText(label: 'Port: $port', color: tokens.textSecondary),
          const Spacer(),
          const _StatusText(label: 'API Dash (Flutter)'),
          const SizedBox(width: Spacing.v12px075remSpacing04),
          const _StatusText(label: 'UTF-8'),
          const SizedBox(width: Spacing.v12px075remSpacing04),
          _AiAgentToggle(isActive: isAiShellVisible, onTap: onToggleAiShell),
        ],
      ),
    );
  }
}

class _PanelToggle extends StatelessWidget {
  const _PanelToggle({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: CButton.icon(
        kind: CButtonKind.ghost,
        size: CButtonSize.sm,
        onTap: onTap,
        icon: Icon(
          icon,
          size: Spacing.v16px1remSpacing05,
          color: context.tokens.iconPrimary,
        ),
      ),
    );
  }
}

class _AiAgentToggle extends StatelessWidget {
  const _AiAgentToggle({required this.isActive, required this.onTap});

  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Tooltip(
      message: 'AI agent',
      child: Container(
        decoration: isActive
            ? BoxDecoration(color: tokens.layerSelected01)
            : null,
        child: CButton.icon(
          kind: CButtonKind.ghost,
          size: CButtonSize.sm,
          onTap: onTap,
          icon: CAiAgentIcon(
            size: Spacing.v16px1remSpacing05,
            color: isActive ? tokens.iconPrimary : tokens.iconSecondary,
          ),
        ),
      ),
    );
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TypeScale.bodyCompact01.copyWith(
        color: color ?? context.tokens.textSecondary,
      ),
    );
  }
}
