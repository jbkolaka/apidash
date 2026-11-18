import 'package:flutter/material.dart';

import '../../core/carbon.dart';

/// Fresh landing page for the rebuilt app.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<CUiShellNavItem> get _shellItems => [
    CUiShellNavItem(
      label: 'Home',
      icon: Icons.home,
      description: 'Landing page',
    ),
    CUiShellNavItem(
      label: 'Workspace',
      icon: Icons.apartment,
      description: 'Workspace landing',
    ),
    CUiShellNavItem(
      label: 'Application inventory',
      icon: Icons.apps,
      description: 'Application inventory',
    ),
    CUiShellNavItem(
      label: 'Public API network',
      icon: Icons.public,
      description: 'Public API network',
    ),
    CUiShellNavItem(
      label: 'Private API network',
      icon: Icons.lock,
      description: 'Private API network',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return CUiShell(
      props: CUiShellProps(
        items: _shellItems,
        title: 'API Dash',
        selectedIndex: _selectedIndex,
        onSelect: (index) => setState(() => _selectedIndex = index),
      ),
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
                  style: TypeScale.body01.copyWith(color: tokens.textSecondary),
                ),
                const SizedBox(height: Spacing.v32px2remSpacing07),
                _GettingStartedCard(tokens: tokens),
              ],
            ),
          ),
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
