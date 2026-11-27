import 'package:flutter/widgets.dart';

/// Node selection behavior for [CTreeView].
enum CTreeViewSelectionMode { none, single, multiple }

/// Where the expand/collapse caret is placed on a branch row.
enum CTreeViewDisclosurePosition { leading, trailing }

/// A trailing action rendered on a [CTreeViewNode] row.
class CTreeViewAction {
  const CTreeViewAction({
    required this.label,
    required this.icon,
    this.onTap,
    this.disabled = false,
  });

  /// Accessible label and tooltip text for the action.
  final String label;

  /// Icon widget displayed at the end of the row.
  final Widget icon;

  /// Callback executed when the action is tapped.
  final VoidCallback? onTap;

  /// Whether the action is non-interactive.
  final bool disabled;
}

/// A node rendered by [CTreeView].
class CTreeViewNode {
  const CTreeViewNode({
    required this.id,
    required this.label,
    this.children = const <CTreeViewNode>[],
    this.icon,
    this.actions = const <CTreeViewAction>[],
    this.disabled = false,
    this.expandedByDefault = false,
  });

  /// Stable unique identifier for this node.
  final String id;

  /// Text displayed for this node.
  final String label;

  /// Child nodes. A non-empty list makes this node expandable.
  final List<CTreeViewNode> children;

  /// Optional icon displayed before the label.
  final Widget? icon;

  /// Trailing actions displayed at the end of the row.
  final List<CTreeViewAction> actions;

  /// Whether the node can be selected or activated.
  final bool disabled;

  /// Whether this branch starts expanded.
  final bool expandedByDefault;
}

/// Configuration for [CTreeView].
class CTreeViewProps {
  const CTreeViewProps({
    this.nodes = const <CTreeViewNode>[],
    this.label = 'Tree view',
    this.emptyText = 'No items available',
    this.selectionMode = CTreeViewSelectionMode.single,
    this.initialSelectedIds = const <String>{},
    this.initialActiveId,
    this.initialExpandedIds = const <String>{},
    this.size = CTreeViewSize.md,
    this.maxHeight,
    this.showActionsOnHover = false,
    this.disclosurePosition = CTreeViewDisclosurePosition.leading,
    this.onSelectionChanged,
    this.onActiveChanged,
    this.onExpandedChanged,
    this.onNodeActivate,
  });

  /// Root nodes to display.
  final List<CTreeViewNode> nodes;

  /// Accessible name for the tree.
  final String label;

  /// Message shown when [nodes] is empty.
  final String emptyText;

  /// Selection behavior for nodes.
  final CTreeViewSelectionMode selectionMode;

  /// Nodes selected on first build.
  final Set<String> initialSelectedIds;

  /// Node to focus when the tree is first built.
  final String? initialActiveId;

  /// Branches expanded on first build, in addition to nodes with
  /// [CTreeViewNode.expandedByDefault].
  final Set<String> initialExpandedIds;

  /// Node row density.
  final CTreeViewSize size;

  /// Optional maximum tree height. Overflowing trees scroll vertically.
  final double? maxHeight;

  /// Renders [CTreeViewNode.actions] only while the row is hovered.
  final bool showActionsOnHover;

  /// Placement of the branch expand/collapse caret.
  ///
  /// Defaults to [CTreeViewDisclosurePosition.leading], matching Carbon's
  /// tree view anatomy. Use [CTreeViewDisclosurePosition.trailing] when row
  /// icons need the leading edge and actions belong before the caret.
  final CTreeViewDisclosurePosition disclosurePosition;

  /// Called when the set of selected node IDs changes.
  final ValueChanged<Set<String>>? onSelectionChanged;

  /// Called when the active node changes.
  final ValueChanged<String>? onActiveChanged;

  /// Called when a branch expands or collapses.
  final ValueChanged<Set<String>>? onExpandedChanged;

  /// Called when a node is activated by tap, Enter, or Space.
  final ValueChanged<CTreeViewNode>? onNodeActivate;
}

/// Node row density variants.
enum CTreeViewSize { sm, md, lg }
