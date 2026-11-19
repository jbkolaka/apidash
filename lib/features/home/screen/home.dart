import 'package:apidash/features/home/widgets/application_body.dart';
import 'package:apidash/features/home/widgets/home_body.dart';
import 'package:apidash/features/home/widgets/setting.dart';
import 'package:flutter/material.dart';

import '../../../core/carbon.dart';
import '../widgets/private_api.dart';
import '../widgets/public_api.dart';
import '../widgets/work_space_body.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    const CUiShellNavItem(
      label: 'Settings',
      icon: Icons.settings,
      description: 'App settings',
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
      child: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomeBody(),
          const WorkSpaceBody(),
          const ApplicationBody(),
          const PublicApi(),
          const PrivateApi(),
          const Setting(),
        ],
      ),
    );
  }
}
