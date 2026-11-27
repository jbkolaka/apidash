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

  String _idFor(String branch) => branch.toLowerCase().replaceAll(' ', '-');

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
          id: 'service:${_idFor(branch)}',
          label: branch,
          icon: Icon(
            WorkspaceCollectionsConfig.branchIcon(_idFor(branch)),
            size: 16,
          ),
        ),
      if (branches.isEmpty)
        CTreeViewNode(
          id: 'services-empty',
          label: 'No services found',
          icon: const Icon(CIcons.folder, size: 16),
          disabled: true,
        ),
    ];

    return SingleChildScrollView(
      child: CTreeView(
        props: CTreeViewProps(
          size: CTreeViewSize.sm,
          label: 'Workspace services',
          selectionMode: CTreeViewSelectionMode.none,
          disclosurePosition: CTreeViewDisclosurePosition.trailing,
          nodes: nodes,
          onNodeActivate: onNodeActivate,
        ),
      ),
    );
  }
}
