import 'package:flutter/material.dart';

import '../../../core/carbon.dart' hide Theme;
import '../widgets/work_space_ai_shell.dart';
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
  bool _isCollectionsVisible = true;
  bool _isResponseVisible = true;
  bool _isAiShellVisible = false;
  bool _isAiShellMaximized = false;
  double _aiShellWidth = 380.0;
  double _collectionWidth = 320.0;

  static const _minCollectionWidth = 280.0;
  static const _maxCollectionWidth = 520.0;
  static const _minWorkbenchWidth = 320.0;
  static const _minAiShellWidth = 300.0;

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
            child: LayoutBuilder(
              builder: (context, constraints) =>
                  _buildWorkspaceLayout(context, constraints.maxWidth),
            ),
          ),
          WorkSpaceStatusBar(
            environment: _selectedEnvironment,
            port: _port,
            isCollectionsVisible: _isCollectionsVisible,
            onToggleCollections: _toggleCollections,
            isResponseVisible: _isResponseVisible,
            onToggleResponse: _toggleResponse,
            isAiShellVisible: _isAiShellVisible,
            onToggleAiShell: _toggleAiShell,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceLayout(BuildContext context, double availableWidth) {
    final showCollections = _isCollectionsVisible && !_isAiShellMaximized;
    final showAiShell = _isAiShellVisible && !_isAiShellMaximized;
    final collectionHandleWidth = showCollections
        ? CResizeHandleStyles.hitThickness
        : 0.0;
    final aiHandleWidth = showAiShell ? CResizeHandleStyles.hitThickness : 0.0;
    final maxAiShellWidth =
        availableWidth -
        (showCollections ? _collectionWidth : 0.0) -
        collectionHandleWidth -
        _minWorkbenchWidth;
    final shellWidth = _clampAiShellWidth(_aiShellWidth, maxAiShellWidth);
    final maxCollectionWidth =
        availableWidth -
        _minWorkbenchWidth -
        collectionHandleWidth -
        (showAiShell ? aiHandleWidth + shellWidth : 0.0);
    final collectionsWidth = _clampCollectionWidth(
      _collectionWidth,
      maxCollectionWidth,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showCollections)
          SizedBox(
            width: collectionsWidth,
            child: WorkSpaceCollectionsPanel(
              collections: _collections,
              environments: _environments,
              onOpenRequest: _openRequest,
              onAddRequest: _addNewTab,
              onEnvironmentSelected: _selectEnvironment,
            ),
          ),
        if (showCollections)
          CResizeHandle(
            key: const Key('workspace-collections-resize-handle'),
            direction: CResizeHandleDirection.horizontal,
            semanticLabel: 'Resize collections panel',
            onDrag: (delta) {
              setState(() {
                _collectionWidth = _clampCollectionWidth(
                  collectionsWidth + delta,
                  maxCollectionWidth,
                );
              });
            },
          ),
        if (!_isAiShellMaximized) Expanded(child: _buildWorkbench(context)),
        if (showAiShell) ...[
          CResizeHandle(
            key: const Key('workspace-ai-shell-resize-handle'),
            direction: CResizeHandleDirection.horizontal,
            semanticLabel: 'Resize AI shell',
            onDrag: (delta) {
              setState(() {
                _aiShellWidth = _clampAiShellWidth(
                  shellWidth - delta,
                  maxAiShellWidth,
                );
              });
            },
          ),
          SizedBox(width: shellWidth, child: _buildAiShell()),
        ],
        if (_isAiShellVisible && _isAiShellMaximized)
          Expanded(child: _buildAiShell()),
      ],
    );
  }

  Widget _buildAiShell() {
    return WorkSpaceAiShell(
      isMaximized: _isAiShellMaximized,
      onClose: _toggleAiShell,
      onToggleMaximize: () =>
          setState(() => _isAiShellMaximized = !_isAiShellMaximized),
    );
  }

  double _clampCollectionWidth(double value, double maxWidth) {
    final upperBound = maxWidth < _maxCollectionWidth
        ? maxWidth
        : _maxCollectionWidth;
    if (upperBound < _minCollectionWidth) return _minCollectionWidth;
    if (value < _minCollectionWidth) return _minCollectionWidth;
    if (value > upperBound) return upperBound;
    return value;
  }

  double _clampAiShellWidth(double value, double maxWidth) {
    if (maxWidth < _minAiShellWidth) return _minAiShellWidth;
    if (value < _minAiShellWidth) return _minAiShellWidth;
    if (value > maxWidth) return maxWidth;
    return value;
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
              if (_isResponseVisible)
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

  void _toggleCollections() {
    setState(() => _isCollectionsVisible = !_isCollectionsVisible);
  }

  void _toggleResponse() {
    setState(() => _isResponseVisible = !_isResponseVisible);
  }

  void _toggleAiShell() {
    setState(() {
      _isAiShellVisible = !_isAiShellVisible;
      if (!_isAiShellVisible) _isAiShellMaximized = false;
    });
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
