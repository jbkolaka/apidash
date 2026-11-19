import 'package:apidash/core/carbon.dart';
import 'package:flutter/material.dart';

/// Fresh landing page for the rebuilt app.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<CMenuEntry> get _navMenuItems => [
    CMenuItem(
      label: 'Home',
      icon: const Icon(Icons.home, size: 16),
      onTap: () {},
    ),
    CSubmenu(
      label: 'Workspace',
      icon: const Icon(Icons.apartment, size: 16),
      items: [
        CMenuItem(
          label: 'Default workspace',
          icon: const Icon(Icons.folder, size: 16),
          onTap: () {},
        ),
        CMenuItem(
          label: 'New workspace',
          icon: const Icon(Icons.add, size: 16),
          onTap: () {},
        ),
      ],
    ),
    CMenuItem(
      label: 'Application inventory',
      icon: const Icon(Icons.apps, size: 16),
      onTap: () {},
    ),
    const CMenuDivider(),
    CMenuItem(
      label: 'Public API network',
      icon: const Icon(Icons.public, size: 16),
      onTap: () {},
    ),
    CMenuItem(
      label: 'Private API network',
      icon: const Icon(Icons.lock, size: 16),
      onTap: () {},
    ),
  ];

  List<CMenuEntry> get _workspaceMenuItems => [
    CMenuItem(
      label: 'Default workspace',
      icon: const Icon(Icons.folder, size: 16),
      onTap: () {},
    ),
    CMenuItem(
      label: 'New workspace',
      icon: const Icon(Icons.add, size: 16),
      onTap: () {},
    ),
    CMenuItem(
      label: 'Delete workspace',
      kind: CMenuItemKind.danger,
      icon: const Icon(Icons.delete_outline, size: 16),
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CUiShellHeader(
              props: CUiShellHeaderProps(
                title: 'API Dash',
                showMenuButton: true,
                menuIcon: Icons.grid_view,
                menuItems: _navMenuItems,
                actions: [
                  CUiShellHeaderAction(
                    label: 'Settings',
                    icon: Icons.settings,
                    onPressed: () {},
                  ),
                ],
                trailing: CMenuButton(
                  props: CMenuButtonProps(
                    label: 'Workspaces',
                    icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                    kind: CMenuButtonKind.ghost,
                    size: CMenuSize.sm,
                    items: _workspaceMenuItems,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 36,
                      constraints: const BoxConstraints(maxWidth: 600),
                      decoration: BoxDecoration(
                        color: tokens.layer01,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: tokens.borderSubtle01),
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: tokens.textSecondary,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: tokens.textSecondary,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(bottom: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacing.v32px2remSpacing07),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WELCOME',
                          style: TypeScale.label01.copyWith(
                            color: tokens.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: Spacing.v8px05remSpacing03),
                        Text(
                          'A new start',
                          style: TypeScale.heading05.copyWith(
                            color: tokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: Spacing.v16px1remSpacing05),
                        Text(
                          'This is a clean shell built with the core Carbon '
                          'theme tokens and components. Add your screens one '
                          'page at a time.',
                          style: TypeScale.body01.copyWith(
                            color: tokens.textSecondary,
                          ),
                        ),
                        const SizedBox(height: Spacing.v32px2remSpacing07),
                        _GettingStartedCard(tokens: tokens),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GettingStartedCard extends StatelessWidget {
  const _GettingStartedCard({required this.tokens});

  final AppThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.v24px15remSpacing06),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border.all(color: tokens.borderSubtle01),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Getting started',
            style: TypeScale.heading03.copyWith(color: tokens.textPrimary),
          ),
          const SizedBox(height: Spacing.v8px05remSpacing03),
          Text(
            'Create a request or import an existing collection.',
            style: TypeScale.bodyCompact01.copyWith(
              color: tokens.textSecondary,
            ),
          ),
          const SizedBox(height: Spacing.v24px15remSpacing06),
          Wrap(
            spacing: Spacing.v12px075remSpacing04,
            runSpacing: Spacing.v8px05remSpacing03,
            children: [
              CButton(
                label: 'Create request',
                icon: const Icon(Icons.add, size: 16),
                onTap: () {},
              ),
              CButton(
                label: 'Import collection',
                kind: CButtonKind.secondary,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: Spacing.v24px15remSpacing06),
          CTextField(label: 'Workspace name', hint: 'e.g. my-workspace'),
        ],
      ),
    );
  }
}
