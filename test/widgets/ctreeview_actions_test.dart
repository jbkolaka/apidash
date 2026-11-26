import 'dart:ui' show PointerDeviceKind;

import 'package:apidash/core/components/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CTreeView renders and dispatches trailing row actions', (
    tester,
  ) async {
    var actionTaps = 0;
    var rowActivations = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CTreeView(
            props: CTreeViewProps(
              selectionMode: CTreeViewSelectionMode.none,
              nodes: [
                CTreeViewNode(
                  id: 'example',
                  label: 'Example',
                  actions: [
                    CTreeViewAction(
                      label: 'Add star',
                      icon: const Icon(Icons.star),
                      onTap: () => actionTaps++,
                    ),
                  ],
                ),
              ],
              onNodeActivate: (_) => rowActivations++,
            ),
          ),
        ),
      ),
    );

    expect(find.byTooltip('Add star'), findsOneWidget);

    await tester.tap(find.byTooltip('Add star'));
    await tester.pumpAndSettle();

    expect(actionTaps, 1);
    expect(rowActivations, 0);
  });

  testWidgets('CTreeView can reveal actions on row hover', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CTreeView(
            props: CTreeViewProps(
              selectionMode: CTreeViewSelectionMode.none,
              showActionsOnHover: true,
              nodes: const [
                CTreeViewNode(id: 'first', label: 'First'),
                CTreeViewNode(
                  id: 'example',
                  label: 'Example',
                  actions: [
                    CTreeViewAction(label: 'Add star', icon: Icon(Icons.star)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byTooltip('Add star'), findsNothing);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.moveTo(tester.getCenter(find.text('Example')));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Add star'), findsOneWidget);

    await gesture.removePointer();
  });

  testWidgets('CTreeView has no outer border', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CTreeView(
            props: CTreeViewProps(
              nodes: [CTreeViewNode(id: 'a', label: 'A')],
            ),
          ),
        ),
      ),
    );

    final decoration = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(CTreeView),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );

    expect((decoration.decoration as BoxDecoration).border, isNull);
  });
}
