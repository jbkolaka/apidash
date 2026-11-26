import 'package:flutter/material.dart';

import '../../../core/carbon.dart';
import 'work_space_collections/index.dart';
import 'work_space_model.dart';

/// Collections and resources panel of the workbench.
class WorkSpaceCollectionsPanel extends StatefulWidget {
  const WorkSpaceCollectionsPanel({
    super.key,
    required this.collections,
    required this.environments,
    required this.onOpenRequest,
    required this.onAddRequest,
    required this.onEnvironmentSelected,
  });

  final List<WorkspaceCollection> collections;
  final List<WorkspaceEnvironment> environments;
  final ValueChanged<WorkspaceRequest> onOpenRequest;
  final VoidCallback onAddRequest;
  final ValueChanged<String> onEnvironmentSelected;

  @override
  State<WorkSpaceCollectionsPanel> createState() =>
      _WorkSpaceCollectionsPanelState();
}

class _WorkSpaceCollectionsPanelState extends State<WorkSpaceCollectionsPanel> {
  String _filter = '';
  final Set<String> _starredIds = <String>{};
  int _selectedViewIndex = 0;

  void _toggleStar(String id) {
    setState(() {
      if (!_starredIds.remove(id)) _starredIds.add(id);
    });
  }

  void _showMenuSpecChart() {
    if (!mounted) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(
      Offset(renderBox.size.width / 2, 0),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      CMenu.showAtPosition(
        context: context,
        position: position,
        props: CMenuSpecChart.props(size: CMenuSize.sm),
      );
    });
    WidgetsBinding.instance.scheduleFrame();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final buildActions = WorkspaceTreeActions.builder(
      starredIds: _starredIds,
      onAddRequest: widget.onAddRequest,
      onToggleStar: _toggleStar,
      onShowMenuSpecChart: _showMenuSpecChart,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkspaceCollectionsHeader(
          addMenuProps: WorkspaceMenuProps.add(
            onAddRequest: widget.onAddRequest,
          ),
          onViewChanged: (index) {
            setState(() => _selectedViewIndex = index);
          },
        ),
        Divider(height: 1, color: tokens.borderSubtle01),
        Padding(
          padding: const EdgeInsets.all(Spacing.v8px05remSpacing03),
          child: CSearch(
            size: CSearchSize.sm,
            placeholder: 'Filter...',
            onChange: (value) => setState(() => _filter = value.toLowerCase()),
          ),
        ),
        Expanded(
          child: _selectedViewIndex == 0
              ? CollectionsTreeView(
                  collections: widget.collections,
                  environments: widget.environments,
                  filter: _filter,
                  buildActions: buildActions,
                  onNodeActivate: _onNodeActivate,
                )
              : ServicesTreeView(
                  filter: _filter,
                  onNodeActivate: _onNodeActivate,
                ),
        ),
      ],
    );
  }

  void _onNodeActivate(CTreeViewNode node) => _openNode(node.id);

  void _openNode(String id) {
    if (id.startsWith('request:')) {
      final requestId = id.substring('request:'.length);
      for (final collection in widget.collections) {
        for (final request in collection.requests) {
          if (request.id == requestId) {
            widget.onOpenRequest(request);
            return;
          }
        }
      }
      return;
    }
    if (id.startsWith('environment:')) {
      widget.onEnvironmentSelected(id.substring('environment:'.length));
    }
  }
}
