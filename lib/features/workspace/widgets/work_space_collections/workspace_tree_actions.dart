import 'package:flutter/material.dart';

import '../../../../core/carbon.dart';
import 'workspace_menu_props.dart';

/// Builds the trailing actions for a workspace tree row.
typedef WorkspaceNodeActionsBuilder = List<CTreeViewAction> Function(String id);

/// Creates tree-row actions from the panel's current local state.
abstract final class WorkspaceTreeActions {
  static WorkspaceNodeActionsBuilder builder({
    required Set<String> starredIds,
    required VoidCallback onAddRequest,
    required ValueChanged<String> onToggleStar,
    required VoidCallback onShowMenuSpecChart,
  }) {
    return (id) {
      final isRequest = id.startsWith('request:');
      final isEnvironment = id.startsWith('environment:');
      final isDocument = id.startsWith('document:');
      final isMock = id.startsWith('mock:');
      final isFlow = id.startsWith('flow:');

      final moreOptions = CTreeViewAction(
        label: 'More options',
        icon: CMenuAnchor(
          props: isRequest
              ? WorkspaceMenuProps.request()
              : isEnvironment
              ? WorkspaceMenuProps.environment()
              : isDocument
              ? WorkspaceMenuProps.document()
              : isMock
              ? WorkspaceMenuProps.mock()
              : isFlow
              ? WorkspaceMenuProps.flow()
              : WorkspaceMenuProps.row(
                  onAddRequest: onAddRequest,
                  onShowMenuSpecChart: onShowMenuSpecChart,
                ),
          builder: (context, openMenu) =>
              iconButton(openMenu, CIcons.overflowMenuVertical),
        ),
      );

      if (isRequest || isDocument || isMock || isFlow) {
        return [moreOptions];
      }

      if (isEnvironment) {
        return [
          CTreeViewAction(
            label: 'Set active',
            icon: const Icon(CIcons.checkmarkOutline),
            onTap: () {},
          ),
          moreOptions,
        ];
      }

      final starred = starredIds.contains(id);
      return [
        CTreeViewAction(
          label: 'Add',
          icon: CMenuAnchor(
            props: WorkspaceMenuProps.add(onAddRequest: onAddRequest),
            builder: (context, openMenu) => iconButton(openMenu, CIcons.add),
          ),
        ),
        CTreeViewAction(
          label: starred ? 'Remove star' : 'Add star',
          icon: Icon(starred ? CIcons.starFilled : CIcons.star),
          onTap: () => onToggleStar(id),
        ),
        moreOptions,
      ];
    };
  }

  static Widget iconButton(VoidCallback openMenu, IconData icon) {
    return IconButton(
      onPressed: openMenu,
      icon: Icon(icon),
      iconSize: CTreeViewStyles.iconSize,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 24, height: 24),
      visualDensity: VisualDensity.compact,
    );
  }
}
