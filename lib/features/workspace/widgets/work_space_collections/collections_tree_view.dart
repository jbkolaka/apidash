import 'package:flutter/material.dart';

import '../../../../core/carbon.dart';
import '../work_space_model.dart';
import 'workspace_collections_config.dart';
import 'workspace_method_tag.dart';
import 'workspace_tree_actions.dart';

/// Collections, environments, and resource tree shown by the first view.
class CollectionsTreeView extends StatelessWidget {
  const CollectionsTreeView({
    super.key,
    required this.collections,
    required this.environments,
    required this.filter,
    required this.buildActions,
    required this.onNodeActivate,
  });

  final List<WorkspaceCollection> collections;
  final List<WorkspaceEnvironment> environments;
  final String filter;
  final WorkspaceNodeActionsBuilder buildActions;
  final ValueChanged<CTreeViewNode> onNodeActivate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CTreeView(
        props: CTreeViewProps(
          size: CTreeViewSize.sm,
          label: 'Workspace collections',
          selectionMode: CTreeViewSelectionMode.none,
          showActionsOnHover: true,
          nodes: _buildNodes(),
          onNodeActivate: onNodeActivate,
        ),
      ),
    );
  }

  bool _matches(String value) =>
      filter.isEmpty || value.toLowerCase().contains(filter);

  List<CTreeViewNode> _buildNodes() {
    final visibleCollections = collections
        .where(
          (collection) =>
              _matches(collection.name) ||
              collection.requests.any((request) => _matches(request.name)),
        )
        .toList();
    final visibleEnvironments = environments
        .where((environment) => _matches(environment.name))
        .toList();

    return [
      CTreeViewNode(
        id: 'section:collections',
        label: 'Collections',
        icon: const Icon(CIcons.folder, size: 16),
        expandedByDefault: true,
        children: _buildCollectionNodes(visibleCollections),
      ),
      CTreeViewNode(
        id: 'section:environments',
        label: 'Environments',
        children: _buildEnvironmentNodes(visibleEnvironments),
      ),
      for (final section in WorkspaceCollectionsConfig.resourceSections)
        _buildResourceNode(section),
    ];
  }

  List<CTreeViewNode> _buildCollectionNodes(
    List<WorkspaceCollection> visibleCollections,
  ) {
    return [
      for (var index = 0; index < visibleCollections.length; index++)
        CTreeViewNode(
          id: 'collection:$index',
          label: visibleCollections[index].name,
          actions: buildActions('collection:$index'),
          expandedByDefault: true,
          children: [
            for (final request in visibleCollections[index].requests)
              CTreeViewNode(
                id: 'request:${request.id}',
                label: request.name,
                icon: WorkspaceMethodTag(method: request.method),
                actions: buildActions('request:${request.id}'),
              ),
          ],
        ),
      if (visibleCollections.isEmpty)
        CTreeViewNode(
          id: 'collections-empty',
          label: 'No collections found',
          actions: buildActions('collections-empty'),
          disabled: true,
        ),
    ];
  }

  List<CTreeViewNode> _buildEnvironmentNodes(
    List<WorkspaceEnvironment> visibleEnvironments,
  ) {
    return [
      for (final environment in visibleEnvironments)
        CTreeViewNode(
          id: 'environment:${environment.name}',
          label: environment.name,
          icon: const Icon(CIcons.globe, size: 16),
          actions: buildActions('environment:${environment.name}'),
        ),
      if (visibleEnvironments.isEmpty)
        CTreeViewNode(
          id: 'environments-empty',
          label: 'No environments found',
          actions: buildActions('environments-empty'),
          disabled: true,
        ),
    ];
  }

  CTreeViewNode _buildResourceNode(String section) {
    final sectionId = section.toLowerCase();
    final childId = switch (section) {
      'Documents' => 'document:documents-empty',
      'Mocks' => 'mock:mocks-empty',
      'Flows' => 'flow:flows-empty',
      _ => 'empty:$sectionId',
    };

    return CTreeViewNode(
      id: 'section:$sectionId',
      label: section,
      children: [
        CTreeViewNode(
          id: childId,
          label: 'No $section found',
          actions: _resourceActions(childId),
          disabled: true,
        ),
      ],
    );
  }

  List<CTreeViewAction> _resourceActions(String childId) {
    if (childId.startsWith('document:') ||
        childId.startsWith('mock:') ||
        childId.startsWith('flow:')) {
      return buildActions(childId);
    }
    return const [];
  }
}
