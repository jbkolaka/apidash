import 'package:flutter/material.dart';

import '../../../../core/carbon.dart';
import 'workspace_collections_config.dart';

/// Services tree shown by the second workspace view switcher option.
class ServicesTreeView extends StatelessWidget {
  const ServicesTreeView({
    super.key,
    required this.filter,
    required this.onNodeActivate,
  });

  final String filter;
  final ValueChanged<CTreeViewNode> onNodeActivate;

  @override
  Widget build(BuildContext context) {
    final branches = WorkspaceCollectionsConfig.serviceBranches
        .where(
          (branch) => filter.isEmpty || branch.toLowerCase().contains(filter),
        )
        .toList();

    final nodes = <CTreeViewNode>[
      for (final branch in branches)
        CTreeViewNode(
          id: 'service:${branch.toLowerCase().replaceAll(' ', '-')}',
          label: branch,
        ),
      if (branches.isEmpty)
        const CTreeViewNode(
          id: 'services-empty',
          label: 'No services found',
          disabled: true,
        ),
    ];

    return SingleChildScrollView(
      child: CTreeView(
        props: CTreeViewProps(
          size: CTreeViewSize.sm,
          label: 'Workspace services',
          selectionMode: CTreeViewSelectionMode.none,
          nodes: nodes,
          onNodeActivate: onNodeActivate,
        ),
      ),
    );
  }
}
