import 'package:flutter/widgets.dart';
import '../../theme/app_theme.dart';

import '../overflow_menu/index.dart';
import '../text/index.dart';

import 'breadcrumb.props.dart';
import 'breadcrumb.styles.dart';
import 'breadcrumbitem.widget.dart';

typedef _Styles = CBreadcrumbStyles;

/// The breadcrumb is a secondary navigation pattern that
/// helps a user understand the hierarchy among levels and
/// navigate back through them.
class CBreadcrumb extends StatelessWidget {
  CBreadcrumb({
    super.key,
    required List<CBreadcrumbItem> children,
    bool noTrailingSlash = true,
    int breadcrumbsLimit = 3,
  }) : assert(breadcrumbsLimit >= 3),
       props = CBreadcrumbProps(
         children: children,
         noTrailingSlash: noTrailingSlash,
         breadcrumbsLimit: breadcrumbsLimit,
       );

  final CBreadcrumbProps props;

  final _menu = COverflowMenuController();
  final _menuKey = GlobalKey();

  List<Widget> _displayAllBreadcrumbs(BuildContext context) {
    final divider = CText(
      data: '/',
      style: TextStyle(color: _Styles.slashColor(context.tokens), fontSize: 14),
    );

    final items = [
      for (final item in props.children) ...[item, divider],
    ];

    if (props.noTrailingSlash) items.removeLast();

    return items;
  }

  List<Widget> _displayOverflowedBreadcrumbs(BuildContext context) {
    var leadingItems = <CBreadcrumbItem>[];
    var hiddenItems = <CBreadcrumbItem>[];
    var trailingItems = <CBreadcrumbItem>[];

    leadingItems.add(props.children.removeAt(0));
    trailingItems.add(props.children.removeLast());
    trailingItems.add(props.children.removeLast());

    trailingItems = List.from(trailingItems.reversed);

    hiddenItems.addAll(props.children);

    final overflowItem = COverflowMenu(
      controller: _menu,
      size: COverflowMenuSize.sm,
      items: _buildMenuItems(hiddenItems),
      child: CBreadcrumbItem(
        key: _menuKey,
        child: CText(data: '...'),
        onTap: () {
          _menu.open();
        },
      ),
    );

    final divider = CText(
      data: '/',
      style: TextStyle(color: _Styles.slashColor(context.tokens), fontSize: 14),
    );

    final items = <Widget>[
      for (final item in leadingItems) ...[item, divider],
      overflowItem,
      divider,
      for (final item in trailingItems) ...[item, divider],
    ];

    if (props.noTrailingSlash) items.removeLast();

    return items;
  }

  List<COverflowMenuItem> _buildMenuItems(List<CBreadcrumbItem> items) {
    return items.map((item) {
      return COverflowMenuItem(
        child: item.props.child,
        onTap: () {
          item.props.onTap();
          _menu.close();
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: props.children.length > props.breadcrumbsLimit
          ? _displayOverflowedBreadcrumbs(context)
          : _displayAllBreadcrumbs(context),
    );
  }
}
