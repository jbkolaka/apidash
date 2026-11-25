import 'package:flutter/material.dart';

import '../../../core/carbon.dart';
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

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v12px075remSpacing04,
            vertical: Spacing.v8px05remSpacing03,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Collections',
                  style: TypeScale.label01.copyWith(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CButton.icon(
                kind: CButtonKind.ghost,
                size: CButtonSize.sm,
                icon: Icon(CIcons.add, size: 16, color: tokens.iconSecondary),
                onTap: widget.onAddRequest,
              ),
            ],
          ),
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
        Expanded(child: _buildCollections(context)),
      ],
    );
  }

  Widget _buildCollections(BuildContext context) {
    const resourceSections = [
      'Documents',
      'Specs',
      'Mocks',
      'Datasets',
      'Toolsets',
      'Flows',
    ];

    return SingleChildScrollView(
      child: CAccordion(
        props: CAccordionProps(
          size: CAccordionSize.sm,
          flush: true,
          allowMultiple: true,
          items: [
            CAccordionItem(
              title: 'Collections',
              initiallyExpanded: true,
              content: _buildCollectionGroups(context),
            ),
            CAccordionItem(
              title: 'Environments',
              content: _buildEnvironmentItems(context),
            ),
            for (final section in resourceSections)
              CAccordionItem(
                title: section,
                content: _emptyState(context, 'No $section found'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionGroups(BuildContext context) {
    final collections = widget.collections.where((collection) {
      if (_filter.isEmpty) return true;
      if (collection.name.toLowerCase().contains(_filter)) return true;
      return collection.requests.any(
        (request) => request.name.toLowerCase().contains(_filter),
      );
    }).toList();

    if (collections.isEmpty) return _emptyState(context);

    return CAccordion(
      props: CAccordionProps(
        size: CAccordionSize.sm,
        flush: true,
        allowMultiple: true,
        items: [
          for (final collection in collections)
            CAccordionItem(
              title: collection.name,
              initiallyExpanded: true,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final request in collection.requests)
                    _RequestTile(
                      request: request,
                      onTap: () => widget.onOpenRequest(request),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentItems(BuildContext context) {
    final items = widget.environments
        .where(
          (environment) =>
              _filter.isEmpty ||
              environment.name.toLowerCase().contains(_filter),
        )
        .map(
          (environment) => CContainedListItem(
            label: environment.name,
            description: '${environment.variables} vars',
            icon: const Icon(CIcons.globe, size: 16),
            onTap: () => widget.onEnvironmentSelected(environment.name),
          ),
        )
        .toList();

    if (items.isEmpty) return _emptyState(context);

    return CContainedList(
      props: CContainedListProps(
        kind: CContainedListKind.disclosed,
        size: CContainedListSize.sm,
        items: items,
      ),
    );
  }

  Widget _emptyState(
    BuildContext context, [
    String message = 'No items found',
  ]) {
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
        child: Text(
          message,
          style: TypeScale.bodyCompact01.copyWith(color: tokens.textSecondary),
        ),
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({required this.request, required this.onTap});

  final WorkspaceRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v12px075remSpacing04,
            vertical: Spacing.v8px05remSpacing03,
          ),
          child: Row(
            children: [
              _MethodTag(method: request.method),
              const SizedBox(width: Spacing.v8px05remSpacing03),
              Expanded(
                child: Text(
                  request.name,
                  overflow: TextOverflow.ellipsis,
                  style: TypeScale.bodyCompact01.copyWith(
                    color: context.tokens.textPrimary,
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

class _MethodTag extends StatelessWidget {
  const _MethodTag({required this.method});

  final String method;

  @override
  Widget build(BuildContext context) {
    final type = switch (method.toUpperCase()) {
      'GET' => CTagType.green,
      'POST' => CTagType.warmGray,
      'PUT' => CTagType.blue,
      'DELETE' => CTagType.red,
      'PATCH' => CTagType.purple,
      _ => CTagType.gray,
    };

    return CTag(text: method, size: CTagSize.sm, type: type);
  }
}
