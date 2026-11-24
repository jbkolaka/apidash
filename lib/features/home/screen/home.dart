import 'package:apidash/features/home/widgets/application_body.dart';
import 'package:apidash/features/home/widgets/home_body.dart';
import 'package:apidash/features/home/widgets/setting.dart';
import 'package:flutter/material.dart';

import '../../../core/carbon.dart';
import '../widgets/private_api.dart';
import '../widgets/work_space_list.dart';
import '../widgets/public_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedNavIndex = 0;

  List<CUiShellNavItem> get _shellItems => [
    CUiShellNavItem(
      label: 'Home',
      icon: CIcons.home,
      description: 'Landing page',
    ),
    CUiShellNavItem(
      label: 'Workspace',
      icon: CIcons.building,
      description: 'Workspace landing',
    ),
    CUiShellNavItem(
      label: 'Application inventory',
      icon: CIcons.apps,
      description: 'Application inventory',
    ),
    CUiShellNavItem(
      label: 'Public API network',
      icon: CIcons.globe,
      description: 'Public API network',
    ),
    CUiShellNavItem(
      label: 'Private API network',
      icon: CIcons.locked,
      description: 'Private API network',
    ),
    const CUiShellNavItem(
      label: 'Settings',
      icon: CIcons.settings,
      description: 'App settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CUiShell(
      props: CUiShellProps(
        items: _shellItems,
        title: 'API Dash',
        selectedIndex: _selectedNavIndex,
        onSelect: (index) => setState(() => _selectedNavIndex = index),
      ),
      child: IndexedStack(
        index: _selectedNavIndex,
        children: const [
          HomeBody(),
          WorkSpaceBody(),
          ApplicationBody(),
          PublicApi(),
          PrivateApi(),
          Setting(),
        ],
      ),
    );
  }
}
