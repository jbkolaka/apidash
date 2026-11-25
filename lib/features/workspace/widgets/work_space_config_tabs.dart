import 'package:flutter/material.dart';

import '../../../core/carbon.dart';
import 'work_space_model.dart';
import 'work_space_tooltip_label.dart';

/// Request configuration tabs: params, authorization, headers, body, settings.
class WorkSpaceConfigTabs extends StatefulWidget {
  const WorkSpaceConfigTabs({
    super.key,
    required this.request,
    required this.onQueryParamsChanged,
    required this.onHeadersChanged,
    required this.onAuthTypeChanged,
    required this.onBearerTokenChanged,
    required this.onBodyTypeChanged,
    required this.onBodyChanged,
  });

  final WorkspaceRequest request;
  final ValueChanged<List<WorkspaceKeyValue>> onQueryParamsChanged;
  final ValueChanged<List<WorkspaceKeyValue>> onHeadersChanged;
  final ValueChanged<WorkspaceAuthType> onAuthTypeChanged;
  final ValueChanged<String> onBearerTokenChanged;
  final ValueChanged<WorkspaceBodyType> onBodyTypeChanged;
  final ValueChanged<String> onBodyChanged;

  @override
  State<WorkSpaceConfigTabs> createState() => _WorkSpaceConfigTabsState();
}

class _WorkSpaceConfigTabsState extends State<WorkSpaceConfigTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final request = widget.request;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CContentSwitcher(
          props: CContentSwitcherProps(
            size: CContentSwitcherSize.sm,
            options: [
              CContentSwitcherOption(
                label: 'Params (${request.queryParams.length})',
              ),
              const CContentSwitcherOption(label: 'Authorization'),
              CContentSwitcherOption(
                label: 'Headers (${request.headers.length})',
              ),
              const CContentSwitcherOption(label: 'Body'),
              const CContentSwitcherOption(label: 'Settings'),
            ],
            onSelectionChanged: (index) =>
                setState(() => _selectedIndex = index),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _KeyValueTab(
                title: 'Query parameters',
                items: request.queryParams,
                onAdd: () => widget.onQueryParamsChanged([
                  ...request.queryParams,
                  const WorkspaceKeyValue(key: '', value: ''),
                ]),
                onChanged: (index, item) {
                  final items = [...request.queryParams];
                  items[index] = item;
                  widget.onQueryParamsChanged(items);
                },
                onRemove: (index) {
                  final items = [...request.queryParams]..removeAt(index);
                  widget.onQueryParamsChanged(items);
                },
              ),
              _AuthTab(
                authType: request.authType,
                token: request.bearerToken,
                onAuthTypeChanged: widget.onAuthTypeChanged,
                onTokenChanged: widget.onBearerTokenChanged,
              ),
              _KeyValueTab(
                title: 'Headers',
                items: request.headers,
                onAdd: () => widget.onHeadersChanged([
                  ...request.headers,
                  const WorkspaceKeyValue(key: '', value: ''),
                ]),
                onChanged: (index, item) {
                  final items = [...request.headers];
                  items[index] = item;
                  widget.onHeadersChanged(items);
                },
                onRemove: (index) {
                  final items = [...request.headers]..removeAt(index);
                  widget.onHeadersChanged(items);
                },
              ),
              _BodyTab(
                bodyType: request.bodyType,
                body: request.rawBody,
                onBodyTypeChanged: widget.onBodyTypeChanged,
                onBodyChanged: widget.onBodyChanged,
              ),
              const _SettingsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class _AuthTab extends StatefulWidget {
  const _AuthTab({
    required this.authType,
    required this.token,
    required this.onAuthTypeChanged,
    required this.onTokenChanged,
  });

  final WorkspaceAuthType authType;
  final String token;
  final ValueChanged<WorkspaceAuthType> onAuthTypeChanged;
  final ValueChanged<String> onTokenChanged;

  @override
  State<_AuthTab> createState() => _AuthTabState();
}

class _AuthTabState extends State<_AuthTab> {
  static const _standardTypes = [
    WorkspaceAuthType.oauth2,
    WorkspaceAuthType.apiKey,
    WorkspaceAuthType.basicAuth,
    WorkspaceAuthType.bearerToken,
    WorkspaceAuthType.digestAuth,
    WorkspaceAuthType.hawkAuthentication,
    WorkspaceAuthType.jwtBearer,
    WorkspaceAuthType.oauth1,
  ];

  static const _vendorTypes = [
    WorkspaceAuthType.akamaiEdgegrid,
    WorkspaceAuthType.asap,
    WorkspaceAuthType.awsSignature,
    WorkspaceAuthType.ntlmAuthentication,
  ];

  VoidCallback? _toggleAuthMenu;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Type',
                style: TypeScale.bodyCompact01.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
              const SizedBox(width: Spacing.v16px1remSpacing05),
              CPopover(
                align: CPopoverAlignment.bottomStart,
                triggerBuilder: (context, toggle, isOpen) {
                  _toggleAuthMenu = toggle;
                  return _buildTrigger(tokens, isOpen, toggle);
                },
                content: _buildAuthMenu(tokens),
              ),
            ],
          ),
          if (widget.authType == WorkspaceAuthType.bearerToken) ...[
            const SizedBox(height: Spacing.v16px1remSpacing05),
            _ControlledTextField(
              key: ValueKey(widget.token),
              initialValue: widget.token,
              hint: 'Paste bearer token here',
              onChanged: widget.onTokenChanged,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrigger(
    AppThemeTokens tokens,
    bool isOpen,
    VoidCallback toggle,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: toggle,
        child: Container(
          width: 220,
          height: 32,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v8px05remSpacing03,
          ),
          decoration: BoxDecoration(
            color: tokens.field01,
            border: Border.all(
              color: isOpen ? tokens.borderInteractive : tokens.borderSubtle01,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.authType.label,
                  overflow: TextOverflow.ellipsis,
                  style: TypeScale.bodyCompact01.copyWith(
                    color: tokens.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.v8px05remSpacing03),
              Icon(CIcons.chevronDown, size: 16, color: tokens.iconSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthMenu(AppThemeTokens tokens) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 420),
      child: SingleChildScrollView(
        child: SizedBox(
          width: 248,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionLabel('Standard Types', tokens),
              for (final type in _standardTypes) _authItem(type, tokens),
              const SizedBox(height: Spacing.v4px025remSpacing02),
              Divider(height: 1, color: tokens.borderSubtle01),
              _sectionLabel('Specific/Vendor Types', tokens),
              for (final type in _vendorTypes) _authItem(type, tokens),
              const SizedBox(height: Spacing.v4px025remSpacing02),
              Divider(height: 1, color: tokens.borderSubtle01),
              _sectionLabel('Other', tokens),
              _authItem(WorkspaceAuthType.none, tokens),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, AppThemeTokens tokens) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Spacing.v8px05remSpacing03,
        bottom: Spacing.v4px025remSpacing02,
      ),
      child: Text(
        label,
        style: TypeScale.label01.copyWith(
          color: tokens.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _authItem(WorkspaceAuthType type, AppThemeTokens tokens) {
    final selected = type == widget.authType;

    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.onAuthTypeChanged(type);
          _toggleAuthMenu?.call();
        },
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v8px05remSpacing03,
          ),
          decoration: BoxDecoration(
            color: selected ? tokens.layerSelected01 : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: selected ? tokens.borderInteractive : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 14,
                child: selected
                    ? Icon(
                        CIcons.checkmark,
                        size: 14,
                        color: tokens.iconPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: Spacing.v8px05remSpacing03),
              Expanded(
                child: Text(
                  type.label,
                  overflow: TextOverflow.ellipsis,
                  style: TypeScale.bodyCompact01.copyWith(
                    color: selected ? tokens.textPrimary : tokens.textSecondary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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

class _BodyTab extends StatefulWidget {
  const _BodyTab({
    required this.bodyType,
    required this.body,
    required this.onBodyTypeChanged,
    required this.onBodyChanged,
  });

  final WorkspaceBodyType bodyType;
  final String body;
  final ValueChanged<WorkspaceBodyType> onBodyTypeChanged;
  final ValueChanged<String> onBodyChanged;

  @override
  State<_BodyTab> createState() => _BodyTabState();
}

class _BodyTabState extends State<_BodyTab> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.body);
  }

  @override
  void didUpdateWidget(covariant _BodyTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.body != _controller.text && widget.body != oldWidget.body) {
      _controller.text = widget.body;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isJson = widget.bodyType == WorkspaceBodyType.json;

    return Padding(
      padding: const EdgeInsets.all(Spacing.v12px075remSpacing04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CContentSwitcher(
            props: CContentSwitcherProps(
              size: CContentSwitcherSize.sm,
              expand: false,
              initialIndex: isJson ? 1 : 0,
              options: const [
                CContentSwitcherOption(label: 'none'),
                CContentSwitcherOption(label: 'raw (JSON)'),
              ],
              onSelectionChanged: (index) => widget.onBodyTypeChanged(
                index == 1 ? WorkspaceBodyType.json : WorkspaceBodyType.none,
              ),
            ),
          ),
          const SizedBox(height: Spacing.v8px05remSpacing03),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(Spacing.v8px05remSpacing03),
              decoration: BoxDecoration(
                color: tokens.field01,
                border: Border.all(color: tokens.borderSubtle01),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                enabled: isJson,
                style: TypeScale.bodyCompact01.copyWith(
                  color: tokens.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Request body (JSON)',
                  hintStyle: TypeScale.bodyCompact01.copyWith(
                    color: tokens.textPlaceholder,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: widget.onBodyChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValueTab extends StatelessWidget {
  const _KeyValueTab({
    required this.title,
    required this.items,
    required this.onAdd,
    required this.onChanged,
    required this.onRemove,
  });

  final String title;
  final List<WorkspaceKeyValue> items;
  final VoidCallback onAdd;
  final void Function(int index, WorkspaceKeyValue item) onChanged;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: const EdgeInsets.all(Spacing.v12px075remSpacing04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TypeScale.label01.copyWith(
                    color: tokens.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CButton(
                label: 'Add row',
                size: CButtonSize.sm,
                kind: CButtonKind.ghost,
                icon: Icon(CIcons.add, size: 14, color: tokens.iconInteractive),
                onTap: onAdd,
              ),
            ],
          ),
          const SizedBox(height: Spacing.v8px05remSpacing03),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: tokens.borderSubtle00),
              itemBuilder: (context, index) => _KeyValueRow(
                key: ValueKey('$index-${items[index].key}'),
                item: items[index],
                onChanged: (item) => onChanged(index, item),
                onRemove: () => onRemove(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlledTextField extends StatefulWidget {
  const _ControlledTextField({
    super.key,
    required this.initialValue,
    required this.hint,
    required this.onChanged,
  });

  final String initialValue;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  State<_ControlledTextField> createState() => _ControlledTextFieldState();
}

class _ControlledTextFieldState extends State<_ControlledTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CTextField(
      controller: _controller,
      hint: widget.hint,
      onChanged: widget.onChanged,
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onRemove,
  });

  final WorkspaceKeyValue item;
  final ValueChanged<WorkspaceKeyValue> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      children: [
        CCheckbox(
          value: item.enabled,
          onChange: (value) => onChanged(item.copyWith(enabled: value)),
        ),
        const SizedBox(width: Spacing.v8px05remSpacing03),
        Expanded(
          flex: 2,
          child: _ControlledTextField(
            initialValue: item.key,
            hint: 'Key',
            onChanged: (value) => onChanged(item.copyWith(key: value)),
          ),
        ),
        const SizedBox(width: Spacing.v8px05remSpacing03),
        Expanded(
          flex: 3,
          child: _ControlledTextField(
            initialValue: item.value,
            hint: 'Value',
            onChanged: (value) => onChanged(item.copyWith(value: value)),
          ),
        ),
        WorkSpaceTooltipLabel(
          label: 'Remove row',
          child: SizedBox(
            width: 14,
            height: 14,
            child: InkWell(
              onTap: onRemove,
              child: Icon(CIcons.close, size: 14, color: tokens.iconSecondary),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatefulWidget {
  const _SettingsTab();

  @override
  State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  bool _followRedirects = true;
  bool _verifySsl = true;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Request settings',
            style: TypeScale.heading03.copyWith(color: tokens.textPrimary),
          ),
          const SizedBox(height: Spacing.v16px1remSpacing05),
          _ToggleSetting(
            label: 'Follow HTTP redirects',
            value: _followRedirects,
            onToggle: (value) => setState(() => _followRedirects = value),
          ),
          _ToggleSetting(
            label: 'Enable SSL certificate verification',
            value: _verifySsl,
            onToggle: (value) => setState(() => _verifySsl = value),
          ),
          const SizedBox(height: Spacing.v8px05remSpacing03),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Request timeout',
                  style: TypeScale.bodyCompact01.copyWith(
                    color: tokens.textPrimary,
                  ),
                ),
              ),
              Text(
                '30000 ms',
                style: TypeScale.bodyCompact01.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  const _ToggleSetting({
    required this.label,
    required this.value,
    required this.onToggle,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.v12px075remSpacing04),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TypeScale.bodyCompact01.copyWith(
                color: tokens.textPrimary,
              ),
            ),
          ),
          CToggle(
            size: CToggleSize.sm,
            showStatusLabel: false,
            value: value,
            onToggle: onToggle,
          ),
        ],
      ),
    );
  }
}
