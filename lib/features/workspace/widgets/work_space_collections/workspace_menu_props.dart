import 'package:flutter/material.dart';

import '../../../../core/carbon.dart';
import 'workspace_collections_config.dart';

/// Builds the context menus used by the workspace collections tree.
abstract final class WorkspaceMenuProps {
  static CMenuProps add({required VoidCallback onAddRequest}) {
    return _menu(
      [
        for (final option in WorkspaceCollectionsConfig.addOptions)
          if (option != 'Search...') CMenuItem(label: option, value: option),
      ],
      onSelect: (value) {
        if (WorkspaceCollectionsConfig.requestTypes.contains(value)) {
          onAddRequest();
        }
      },
    );
  }

  static CMenuProps request() {
    return _menu(const [
      CMenuItem(label: 'Add example', value: 'add-example'),
      CMenuDivider(),
      CMenuItem(label: 'Share', value: 'share'),
      CMenuItem(label: 'Copy link', value: 'copy-link'),
      CMenuDivider(),
      CMenuItem(label: 'Ask AI', value: 'ask-ai'),
      CMenuDivider(),
      CMenuItem(label: 'Rename', shortcut: 'Ctrl+E', value: 'rename'),
      CMenuItem(label: 'Copy', shortcut: 'Ctrl+C', value: 'copy'),
      CMenuItem(label: 'Duplicate', shortcut: 'Ctrl+D', value: 'duplicate'),
      CMenuItem(
        label: 'Delete',
        shortcut: 'Del',
        kind: CMenuItemKind.danger,
        value: 'delete',
      ),
    ]);
  }

  static CMenuProps environment() {
    return _menu(const [
      CMenuItem(label: 'Share', value: 'share'),
      CMenuItem(label: 'Copy Link', value: 'copy-link'),
      CMenuItem(label: 'Export', value: 'export'),
      CMenuDivider(),
      CMenuItem(label: 'Move', value: 'move'),
      CMenuDivider(),
      CMenuItem(label: 'Fork', shortcut: 'Ctrl+Alt+F', value: 'fork'),
      CMenuDivider(),
      CMenuItem(label: 'Rename', shortcut: 'Ctrl+E', value: 'rename'),
      CMenuItem(label: 'Duplicate', shortcut: 'Ctrl+D', value: 'duplicate'),
      CMenuItem(
        label: 'Delete',
        shortcut: 'Del',
        kind: CMenuItemKind.danger,
        value: 'delete',
      ),
    ]);
  }

  static CMenuProps document() {
    return _menu(const [
      CMenuItem(label: 'Copy link', value: 'copy-link'),
      CMenuDivider(),
      CMenuItem(label: 'Rename', value: 'rename'),
      CMenuItem(label: 'Duplicate', value: 'duplicate'),
      CMenuDivider(),
      CMenuItem(label: 'Delete', kind: CMenuItemKind.danger, value: 'delete'),
    ]);
  }

  static CMenuProps mock() {
    return _menu(const [
      CMenuItem(label: 'Deploy', value: 'deploy'),
      CMenuItem(label: 'Copy link', value: 'copy-link'),
      CMenuItem(label: 'Rename', shortcut: 'Ctrl+E', value: 'rename'),
      CMenuDivider(),
      CMenuItem(
        label: 'Delete',
        shortcut: 'Del',
        kind: CMenuItemKind.danger,
        value: 'delete',
      ),
    ]);
  }

  static CMenuProps flow() {
    return _menu(const [
      CMenuItem(label: 'Rename', shortcut: 'Ctrl+E', value: 'rename'),
      CMenuItem(label: 'Move', value: 'move'),
      CMenuItem(label: 'Duplicate', shortcut: 'Ctrl+D', value: 'duplicate'),
      CMenuItem(label: 'Clone', value: 'clone'),
      CMenuItem(label: 'Copy flow link', value: 'copy-flow-link'),
      CMenuItem(
        label: 'View analytics',
        hasExternalIcon: true,
        value: 'view-analytics',
      ),
      CMenuItem(
        label: 'Delete',
        shortcut: 'Del',
        kind: CMenuItemKind.danger,
        value: 'delete',
      ),
    ]);
  }

  static CMenuProps row({
    required VoidCallback onAddRequest,
    required VoidCallback onShowMenuSpecChart,
  }) {
    return _menu(
      [
        const CMenuItem(label: 'Add request', value: 'add-request'),
        const CMenuItem(label: 'Add folder', value: 'add-folder'),
        const CMenuItem(label: 'Run', value: 'run'),
        const CMenuItem(label: 'Share', value: 'share'),
        const CMenuItem(label: 'Copy link', value: 'copy-link'),
        const CMenuItem(label: 'Ask AI', value: 'ask-ai'),
        const CMenuDivider(),
        const CMenuItem(label: 'Move', value: 'move'),
        const CMenuItem(
          label: 'Use / Fork',
          shortcut: 'Ctrl+Alt+F',
          value: 'use-fork',
        ),
        const CMenuItem(label: 'Rename', shortcut: 'Ctrl+E', value: 'rename'),
        const CMenuItem(
          label: 'Duplicate',
          shortcut: 'Ctrl+D',
          value: 'duplicate',
        ),
        const CSubmenu(
          label: 'Sort',
          items: [
            CMenuItem(label: 'Folders first, Default', value: 'sort-default'),
            CMenuItem(label: 'Folders first, A to Z', value: 'sort-az'),
            CMenuCaption(text: 'This only updates your view in the sidebar.'),
          ],
        ),
        const CMenuItem(
          label: 'Delete',
          shortcut: 'Del',
          kind: CMenuItemKind.danger,
          value: 'delete',
        ),
        const CMenuDivider(),
        const CSubmenu(
          label: 'More',
          items: [
            CMenuItem(label: 'Create mock server', value: 'create-mock-server'),
            CMenuItem(label: 'Create monitor', value: 'create-monitor'),
            CMenuItem(label: 'Generate tests', value: 'generate-tests'),
            CMenuItem(
              label: 'Generate specification',
              value: 'generate-specification',
            ),
            CSubmenu(
              label: 'Export collection',
              items: [
                CMenuItem(label: 'Share with teammates', value: 'share-team'),
                CMenuItem(label: 'Run in CI/CD', value: 'run-cicd'),
                CMenuItem(label: 'Store in a Git repo', value: 'store-git'),
                CMenuItem(label: 'Other', value: 'export-other'),
              ],
            ),
            CMenuItem(label: 'Menu spec', value: 'menu-spec'),
          ],
        ),
      ],
      onSelect: (value) {
        if (value == 'add-request') onAddRequest();
        if (value == 'menu-spec') onShowMenuSpecChart();
      },
    );
  }

  static CMenuProps _menu(
    List<CMenuEntry> items, {
    ValueChanged<dynamic>? onSelect,
  }) {
    return CMenuProps(
      size: CMenuSize.sm,
      minWidth: 240,
      maxWidth: 320,
      items: items,
      onSelect: onSelect,
    );
  }
}
