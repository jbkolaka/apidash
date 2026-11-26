import 'package:apidash/core/carbon.dart';
import 'package:apidash/features/workspace/widgets/work_space_collections_panel.dart';
import 'package:apidash/features/workspace/widgets/work_space_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('workspace switcher selects collections or services tree', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final requests = workspaceSeedRequests();
    final collections = workspaceSeedCollections(requests);

    await tester.pumpWidget(
      AppThemeScope(
        controller: AppThemeController(),
        child: MaterialApp(
          theme: AppTheme.whiteTheme,
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: WorkSpaceCollectionsPanel(
                collections: collections,
                environments: const [],
                onOpenRequest: (_) {},
                onAddRequest: () {},
                onEnvironmentSelected: (_) {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CContentSwitcher), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(CContentSwitcher),
        matching: find.byIcon(CIcons.box),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(CContentSwitcher),
        matching: find.byIcon(CIcons.toolBox),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(CContentSwitcher),
        matching: find.text('Collections'),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(CContentSwitcher),
        matching: find.text('Services'),
      ),
      findsNothing,
    );
    expect(find.text('Core Services API'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(CContentSwitcher),
        matching: find.byIcon(CIcons.toolBox),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Core Services API'), findsNothing);
    for (final branch in [
      'MOCK SERVERS',
      'MONITORS',
      'WEBHOOKS',
      'INSIGHTS',
      'DEPLOYED FLOWS',
    ]) {
      expect(find.text(branch), findsOneWidget, reason: branch);
    }

    await tester.tap(find.byIcon(CIcons.add).first);
    await tester.pumpAndSettle();
    expect(find.text('Collection'), findsOneWidget);
    expect(find.text('Mock Server'), findsOneWidget);
  });
}
