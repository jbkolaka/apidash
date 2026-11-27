import 'package:flutter/material.dart';

import '../../../core/carbon.dart';

/// Zed-style agent dock shown on the right side of the workspace.
///
/// This is currently a static layout preview: it shows the dock, toolbar,
/// thread area, and composer without running any AI or thread actions.
class WorkSpaceAiShell extends StatelessWidget {
  static const _maxContentWidth = 850.0;

  const WorkSpaceAiShell({
    super.key,
    required this.isMaximized,
    required this.onClose,
    required this.onToggleMaximize,
  });

  final bool isMaximized;
  final VoidCallback onClose;
  final VoidCallback onToggleMaximize;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      key: const Key('workspace-ai-shell'),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border(
          left: isMaximized
              ? BorderSide.none
              : BorderSide(color: tokens.borderSubtle01),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildToolbar(context),
          Expanded(child: _buildEmptyState(context)),
          _buildComposer(context),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      height: Spacing.v40px25remSpacing08,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.v8px05remSpacing03,
      ),
      decoration: BoxDecoration(
        color: tokens.layer02,
        border: Border(bottom: BorderSide(color: tokens.borderSubtle01)),
      ),
      child: Row(
        children: [
          const SizedBox(width: Spacing.v4px025remSpacing02),
          CAiAgentIcon(
            size: Spacing.v16px1remSpacing05,
            color: tokens.iconPrimary,
          ),
          const SizedBox(width: Spacing.v8px05remSpacing03),
          Text(
            'Agent',
            style: TypeScale.heading01.copyWith(color: tokens.textPrimary),
          ),
          const Spacer(),
          Tooltip(
            message: 'New thread',
            child: CButton.icon(
              kind: CButtonKind.ghost,
              size: CButtonSize.sm,
              enable: false,
              onTap: () {},
              icon: Icon(
                CIcons.add,
                size: Spacing.v16px1remSpacing05,
                color: tokens.iconSecondary,
              ),
            ),
          ),
          Tooltip(
            message: isMaximized ? 'Restore AI shell' : 'Maximize AI shell',
            child: CButton.icon(
              kind: CButtonKind.ghost,
              size: CButtonSize.sm,
              onTap: onToggleMaximize,
              icon: Icon(
                isMaximized ? CIcons.minimize : CIcons.maximize,
                size: Spacing.v16px1remSpacing05,
                color: tokens.iconPrimary,
              ),
            ),
          ),
          Tooltip(
            message: 'Close AI shell',
            child: CButton.icon(
              kind: CButtonKind.ghost,
              size: CButtonSize.sm,
              onTap: onClose,
              icon: Icon(
                CIcons.close,
                size: Spacing.v16px1remSpacing05,
                color: tokens.iconPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final tokens = context.tokens;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.v24px15remSpacing06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CAiAgentIcon(
              size: Spacing.v32px2remSpacing07,
              color: tokens.iconPrimary,
            ),
            const SizedBox(height: Spacing.v12px075remSpacing04),
            Text(
              'New thread',
              style: TypeScale.heading03.copyWith(color: tokens.textPrimary),
            ),
            const SizedBox(height: Spacing.v4px025remSpacing02),
            Text(
              'Ask the agent about this request.',
              textAlign: TextAlign.center,
              style: TypeScale.bodyCompact01.copyWith(
                color: tokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.all(Spacing.v8px05remSpacing03),
      decoration: BoxDecoration(
        color: tokens.layer02,
        border: Border(top: BorderSide(color: tokens.borderSubtle01)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CTextField(
                  semanticLabel: 'Agent prompt',
                  hint: 'Ask the agent',
                  enable: false,
                ),
              ),
              const SizedBox(width: Spacing.v8px05remSpacing03),
              Tooltip(
                message: 'Send prompt',
                child: CButton.icon(
                  kind: CButtonKind.primary,
                  size: CButtonSize.sm,
                  enable: false,
                  onTap: () {},
                  icon: Icon(
                    CIcons.sendFilled,
                    size: Spacing.v16px1remSpacing05,
                    color: tokens.iconOnColor,
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
