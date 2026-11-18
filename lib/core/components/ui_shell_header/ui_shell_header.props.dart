import 'package:flutter/widgets.dart';

import '../icon/index.dart';
import '../menu/index.dart';

/// A navigation link displayed in a [CUiShellHeader].
class CUiShellHeaderLink {
  const CUiShellHeaderLink({
    required this.label,
    this.onPressed,
    this.isCurrent = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isCurrent;
}

/// An accessible icon action displayed at the end of a [CUiShellHeader].
class CUiShellHeaderAction {
  const CUiShellHeaderAction({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
}

/// Configuration for a Carbon-style application header.
class CUiShellHeaderProps {
  const CUiShellHeaderProps({
    required this.title,
    this.prefix,
    this.links = const [],
    this.actions = const [],
    this.menuItems = const [],
    this.menuIcon = CIcons.menu,
    this.trailing,
    this.onMenuPressed,
    this.onTitlePressed,
    this.showMenuButton = true,
    this.height,
  });

  final String title;
  final String? prefix;
  final List<CUiShellHeaderLink> links;
  final List<CUiShellHeaderAction> actions;

  /// Entries shown when the header menu button is pressed.
  final List<CMenuEntry> menuItems;

  /// Icon used by the header menu button.
  final IconData menuIcon;

  /// Optional widget shown before the header actions (for example a
  /// workspace menu button).
  final Widget? trailing;

  final VoidCallback? onMenuPressed;
  final VoidCallback? onTitlePressed;
  final bool showMenuButton;
  final double? height;
}
