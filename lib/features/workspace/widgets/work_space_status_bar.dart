import 'package:flutter/material.dart';

import '../../../core/carbon.dart';

/// Workbench status strip with connection, environment, and version metadata.
class WorkSpaceStatusBar extends StatelessWidget {
  const WorkSpaceStatusBar({
    super.key,
    required this.environment,
    required this.port,
  });

  final String? environment;
  final int port;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      height: Spacing.v24px15remSpacing06,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.v12px075remSpacing04,
      ),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border(top: BorderSide(color: tokens.borderSubtle01)),
      ),
      child: Row(
        children: [
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
        ],
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
