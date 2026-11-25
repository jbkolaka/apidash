import 'package:flutter/material.dart';

import '../../../core/carbon.dart' hide Theme;
import '../widgets/work_space_collections_panel.dart';
import '../widgets/work_space_config_tabs.dart';
import '../widgets/work_space_header.dart';
import '../widgets/work_space_model.dart';
import '../widgets/work_space_response_viewer.dart';
import '../widgets/work_space_status_bar.dart';
import '../widgets/work_space_tabs_bar.dart';
import '../widgets/work_space_url_bar.dart';

/// Full-width API workbench rendered when Workspace is selected in the shell.
class WorkSpace extends StatefulWidget {
  const WorkSpace({super.key});

  @override
  State<WorkSpace> createState() => _WorkSpaceState();
}

class _WorkSpaceState extends State<WorkSpace> {
  static const _port = 10534;

  late final List<WorkspaceRequest> _seedRequests;
  late List<WorkspaceRequest> _openTabs;
  late List<WorkspaceRequest> _history;
  late List<WorkspaceCollection> _collections;
  late final List<WorkspaceEnvironment> _environments;
  late final Map<String, WorkspaceResponse> _responses;

  int _activeTabIndex = 0;
  String? _selectedEnvironment;
  bool _isLoading = false;

  static const _collectionWidth = 320.0;

  WorkspaceRequest? get _activeRequest =>
      _openTabs.isNotEmpty && _activeTabIndex < _openTabs.length
      ? _openTabs[_activeTabIndex]
      : null;

  @override
  void initState() {
    super.initState();
    _seedRequests = workspaceSeedRequests();
    _openTabs = [_seedRequests.first];
    _history = [_seedRequests.first, workspaceVaultAuthRequest()];
    _collections = workspaceSeedCollections(_seedRequests);
    _environments = workspaceSeedEnvironments();
    _responses = {_seedRequests.first.id: workspaceSampleResponse()};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WorkSpaceHeader(
            environment: _selectedEnvironment,
            environments: _environments.map((item) => item.name).toList(),
            onEnvironmentChanged: (environment) =>
                setState(() => _selectedEnvironment = environment),
            onBack: () => Navigator.of(context).maybePop(),
            collectionName: _collections.isNotEmpty
                ? _collections.first.name
                : 'Collections',
            requestName: _activeRequest?.name ?? 'Workbench',
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: _collectionWidth,
                  child: WorkSpaceCollectionsPanel(
                    collections: _collections,
                    environments: _environments,
                    onOpenRequest: _openRequest,
                    onAddRequest: _addNewTab,
                    onEnvironmentSelected: _selectEnvironment,
                  ),
                ),
                Expanded(child: _buildWorkbench(context)),
              ],
            ),
          ),
          WorkSpaceStatusBar(environment: _selectedEnvironment, port: _port),
        ],
      ),
    );
  }

  Widget _buildWorkbench(BuildContext context) {
    final request = _activeRequest;
    if (request == null) return const SizedBox.expand();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkSpaceTabsBar(
          requests: _openTabs,
          activeIndex: _activeTabIndex,
          onSelected: (index) => setState(() => _activeTabIndex = index),
          onClosed: _closeTab,
          onAdded: _addNewTab,
        ),
        WorkSpaceUrlBar(
          request: request,
          loading: _isLoading,
          onMethodChanged: (method) =>
              _updateActiveRequest(request.copyWith(method: method)),
          onUrlChanged: (url) =>
              _updateActiveRequest(request.copyWith(url: url)),
          onSend: _sendActiveRequest,
          onSave: _saveActiveRequest,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.tokens.layer01,
                    border: Border(
                      bottom: BorderSide(color: context.tokens.borderSubtle01),
                    ),
                  ),
                  child: WorkSpaceConfigTabs(
                    request: request,
                    onQueryParamsChanged: (items) => _updateActiveRequest(
                      request.copyWith(queryParams: items),
                    ),
                    onHeadersChanged: (items) =>
                        _updateActiveRequest(request.copyWith(headers: items)),
                    onAuthTypeChanged: (type) =>
                        _updateActiveRequest(request.copyWith(authType: type)),
                    onBearerTokenChanged: (token) => _updateActiveRequest(
                      request.copyWith(bearerToken: token),
                    ),
                    onBodyTypeChanged: (type) =>
                        _updateActiveRequest(request.copyWith(bodyType: type)),
                    onBodyChanged: (body) =>
                        _updateActiveRequest(request.copyWith(rawBody: body)),
                  ),
                ),
              ),
              Expanded(
                child: WorkSpaceResponseViewer(
                  response: _responses[request.id],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _selectEnvironment(String environment) {
    setState(() => _selectedEnvironment = environment);
  }

  void _openRequest(WorkspaceRequest request) {
    setState(() {
      final existingIndex = _openTabs.indexWhere(
        (item) => item.id == request.id,
      );
      if (existingIndex == -1) {
        _openTabs.add(request);
        _activeTabIndex = _openTabs.length - 1;
      } else {
        _activeTabIndex = existingIndex;
      }
    });
  }

  void _addNewTab() {
    final request = WorkspaceRequest(
      id: 'req-${DateTime.now().microsecondsSinceEpoch}',
      name: 'Untitled Request',
      method: 'GET',
      url: 'https://api.example.com/v1',
    );

    setState(() {
      _openTabs.add(request);
      _activeTabIndex = _openTabs.length - 1;
    });
  }

  void _closeTab(int index) {
    if (index < 0 || index >= _openTabs.length) return;

    setState(() {
      final removed = _openTabs.removeAt(index);
      _responses.remove(removed.id);
      if (_openTabs.isEmpty) {
        final replacement = WorkspaceRequest(
          id: 'req-${DateTime.now().microsecondsSinceEpoch}',
          name: 'Untitled Request',
          method: 'GET',
          url: 'https://api.example.com/v1',
        );
        _openTabs.add(replacement);
        _activeTabIndex = 0;
      } else if (_activeTabIndex >= _openTabs.length) {
        _activeTabIndex = _openTabs.length - 1;
      } else if (_activeTabIndex > index) {
        _activeTabIndex -= 1;
      }
    });
  }

  void _updateActiveRequest(WorkspaceRequest request) {
    setState(() {
      _openTabs = _replaceRequest(_openTabs, request);
      _history = _replaceRequest(_history, request);
      _collections = [
        for (final collection in _collections)
          WorkspaceCollection(
            name: collection.name,
            requests: _replaceRequest(collection.requests, request),
          ),
      ];
    });
  }

  List<WorkspaceRequest> _replaceRequest(
    List<WorkspaceRequest> items,
    WorkspaceRequest request,
  ) {
    final index = items.indexWhere((item) => item.id == request.id);
    if (index == -1) return items;
    return [...items.sublist(0, index), request, ...items.sublist(index + 1)];
  }

  Future<void> _sendActiveRequest() async {
    final request = _activeRequest;
    if (request == null || _isLoading) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    setState(() {
      _responses[request.id] = workspaceSampleResponse();
      if (_history.isEmpty ||
          _history.first.url != request.url ||
          _history.first.method != request.method) {
        _history.insert(
          0,
          request.copyWith(id: 'hist-${DateTime.now().microsecondsSinceEpoch}'),
        );
      }
      _isLoading = false;
    });
  }

  void _saveActiveRequest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request saved to workspace'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
