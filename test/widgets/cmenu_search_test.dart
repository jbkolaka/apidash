import 'dart:ui' show PointerDeviceKind;

import 'package:apidash/core/components/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CMenu search filters items and reports selection', (
    tester,
  ) async {
    dynamic selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CMenu(
            props: CMenuProps(
              searchable: true,
              items: const [
                CMenuItem(label: 'HTTP', value: 'HTTP'),
                CMenuItem(label: 'GraphQL', value: 'GraphQL'),
                CMenuItem(label: 'Collection', value: 'Collection'),
              ],
              onSelect: (value) => selected = value,
            ),
          ),
        ),
      ),
    );

    expect(find.text('HTTP'), findsOneWidget);
    expect(find.text('GraphQL'), findsOneWidget);
    expect(find.text('Collection'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'graph');
    await tester.pumpAndSettle();

    expect(find.text('GraphQL'), findsOneWidget);
    expect(find.text('HTTP'), findsNothing);
    expect(find.text('Collection'), findsNothing);

    await tester.tap(find.text('GraphQL'));
    await tester.pumpAndSettle();

    expect(selected, 'GraphQL');
  });

  testWidgets('CMenu renders an external-link indicator', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CMenu(
            props: CMenuProps(
              items: const [
                CMenuItem(
                  label: 'View analytics',
                  hasExternalIcon: true,
                  value: 'analytics',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('View analytics'), findsOneWidget);
    expect(find.byIcon(CIcons.launch), findsOneWidget);
  });

  testWidgets('CMenu submenu selection removes its overlay once', (
    tester,
  ) async {
    dynamic selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CMenu(
            props: CMenuProps(
              items: const [
                CSubmenu(
                  label: 'Sort',
                  items: [CMenuItem(label: 'Default', value: 'default')],
                ),
              ],
              onSelect: (value) => selected = value,
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.moveTo(tester.getCenter(find.text('Sort')));
    await tester.pumpAndSettle();

    expect(find.text('Default'), findsOneWidget);
    expect(
      find.ancestor(of: find.text('Default'), matching: find.byType(Material)),
      findsWidgets,
    );

    await tester.tap(find.text('Default'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(selected, 'default');

    await gesture.removePointer();
    await tester.pumpAndSettle();
  });

  testWidgets('CMenu nested submenus close without duplicate overlay removal', (
    tester,
  ) async {
    dynamic selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CMenu(
            props: CMenuProps(
              items: const [
                CSubmenu(
                  label: 'More',
                  items: [
                    CSubmenu(
                      label: 'Export collection',
                      items: [CMenuItem(label: 'Other', value: 'other')],
                    ),
                  ],
                ),
              ],
              onSelect: (value) => selected = value,
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.moveTo(tester.getCenter(find.text('More')));
    await tester.pumpAndSettle();
    expect(find.text('Export collection'), findsOneWidget);

    await gesture.moveTo(tester.getCenter(find.text('Export collection')));
    await tester.pumpAndSettle();
    expect(find.text('Other'), findsOneWidget);

    await tester.tap(find.text('Other'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(selected, 'other');

    await gesture.removePointer();
    await tester.pumpAndSettle();
  });
}
