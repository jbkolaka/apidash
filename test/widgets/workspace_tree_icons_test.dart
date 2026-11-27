import 'package:apidash/core/carbon.dart';
import 'package:apidash/features/workspace/widgets/work_space_collections/collections_tree_view.dart';
import 'package:apidash/features/workspace/widgets/work_space_collections/services_tree_view.dart';
import 'package:apidash/features/workspace/widgets/work_space_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('workspace collection branches render Carbon node icons', (
    tester,
  ) async {
    final requests = workspaceSeedRequests();

    await tester.pumpWidget(
      AppThemeScope(
        controller: AppThemeController(),
        child: MaterialApp(
          theme: AppTheme.whiteTheme,
          home: Scaffold(
            body: CollectionsTreeView(
              collections: workspaceSeedCollections(requests),
              environments: workspaceSeedEnvironments(),
              filter: '',
              buildActions: (_) => const <CTreeViewAction>[],
              onNodeActivate: (_) {},
            ),
          ),
        ),
      ),
    );

    for (final icon in [
      CIcons.folder,
      CIcons.globe,
      CIcons.document,
      CIcons.code,
      CIcons.modelAlt,
      CIcons.flow,
    ]) {
      expect(find.byIcon(icon), findsWidgets, reason: icon.toString());
    }
  });

  testWidgets('workspace service branches render Carbon node icons', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppThemeScope(
        controller: AppThemeController(),
        child: MaterialApp(
          theme: AppTheme.whiteTheme,
          home: Scaffold(
            body: ServicesTreeView(filter: '', onNodeActivate: (_) {}),
          ),
        ),
      ),
    );

    final expectedIcons = {
      'Mock servers': CIcons.dataBase,
      'Monitors': CIcons.chartLine,
      'Webhooks': CIcons.events,
      'Insights': CIcons.chartNetwork,
      'Deployed flows': CIcons.flow,
    };

    for (final MapEntry(:key, :value) in expectedIcons.entries) {
      final row = find.ancestor(of: find.text(key), matching: find.byType(Row));
      expect(
        find.descendant(of: row, matching: find.byIcon(value)),
        findsOneWidget,
        reason: key,
      );
    }
  });
}
