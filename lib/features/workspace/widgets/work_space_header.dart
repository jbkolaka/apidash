import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../../../consts.dart';
import '../../../core/carbon.dart' hide Theme;

/// Slim workbench title strip with breadcrumb navigation.
class WorkSpaceHeader extends StatelessWidget {
  const WorkSpaceHeader({
    super.key,
    required this.environment,
    required this.environments,
    required this.onEnvironmentChanged,
    this.onBack,
    this.collectionName = 'Collections',
    this.requestName = 'Workbench',
  });

  final String? environment;
  final List<String> environments;
  final ValueChanged<String?> onEnvironmentChanged;
  final VoidCallback? onBack;
  final String collectionName;
  final String requestName;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final brightness = Theme.of(context).brightness;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;

        Future<void> toggleMaximize() async {
          if (await windowManager.isMaximized()) {
            await windowManager.unmaximize();
          } else {
            await windowManager.maximize();
          }
        }

        final trailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              width: compact ? 116 : 132,
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
            if (kIsDesktop) ...[
              const SizedBox(width: Spacing.v4px025remSpacing02),
              WindowCaptionButton.minimize(
                brightness: brightness,
                onPressed: () async {
                  if (await windowManager.isMinimized()) {
                    await windowManager.restore();
                  } else {
                    await windowManager.minimize();
                  }
                },
              ),
              WindowCaptionButton.maximize(
                brightness: brightness,
                onPressed: toggleMaximize,
              ),
              WindowCaptionButton.close(
                brightness: brightness,
                onPressed: windowManager.close,
              ),
            ],
          ],
        );

        return Container(
          height: Spacing.v40px25remSpacing08,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v16px1remSpacing05,
          ),
          decoration: BoxDecoration(
            color: tokens.background,
            border: Border(bottom: BorderSide(color: tokens.borderSubtle00)),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: kIsDesktop
                ? (_) => windowManager.startDragging()
                : null,
            child: Row(
              children: [
                Expanded(
                  child: CBreadcrumb(
                    children: [
                      CBreadcrumbItem(
                        onTap: onBack ?? () {},
                        child: Text(
                          'My Workspace',
                          style: TypeScale.bodyCompact01,
                        ),
                      ),
                      CBreadcrumbItem(
                        onTap: onBack ?? () {},
                        child: Text(
                          collectionName,
                          overflow: TextOverflow.ellipsis,
                          style: TypeScale.bodyCompact01,
                        ),
                      ),
                      CBreadcrumbItem(
                        isCurrentPage: true,
                        onTap: () {},
                        child: Text(
                          requestName,
                          overflow: TextOverflow.ellipsis,
                          style: TypeScale.bodyCompact01,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.v8px05remSpacing03),
                trailing,
              ],
            ),
          ),
        );
      },
    );
  }
}
