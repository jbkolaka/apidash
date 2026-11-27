import 'package:apidash/core/carbon.dart';
import 'package:apidash/features/workspace/widgets/work_space_collections/workspace_menu_props.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('add menu groups entries with Carbon dividers', () {
    final props = WorkspaceMenuProps.add(onAddRequest: () {});

    final labels = props.items.map((entry) {
      return switch (entry) {
        CMenuItem() => entry.label,
        CMenuDivider() => '---',
        _ => throw StateError('Unexpected add menu entry: $entry'),
      };
    }).toList();

    expect(labels, [
      'Ask AI',
      '---',
      'HTTP',
      'GraphQL',
      'AI',
      'MCP',
      'gRPC',
      'WebSocket',
      'Socket.IO',
      'MQTT',
      'Data',
      'Kafka',
      '---',
      'Collection',
      'Environment',
      'Document',
      'Spec',
      'Mock',
      'Mock Server',
      'Monitor',
      'Webhook',
      'Flow',
      'Dataset',
      'AI Toolset',
    ]);

    final askAi = props.items.whereType<CMenuItem>().first;
    expect(askAi.shortcut, 'Ctrl+Alt+P');
  });

  testWidgets('add menu entries use Carbon icons', (tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final props = WorkspaceMenuProps.add(onAddRequest: () {});

    await tester.pumpWidget(
      AppThemeScope(
        controller: AppThemeController(),
        child: MaterialApp(
          theme: AppTheme.whiteTheme,
          home: Scaffold(body: CMenu(props: props)),
        ),
      ),
    );

    final entries = <String, IconData>{
      'Ask AI': CIcons.magicWand,
      'HTTP': CIcons.api,
      'GraphQL': CIcons.dataStructured,
      'AI': CIcons.machineLearningModel,
      'MCP': CIcons.connect,
      'gRPC': CIcons.connectionSignal,
      'WebSocket': CIcons.flowStream,
      'Socket.IO': CIcons.flowConnection,
      'MQTT': CIcons.flowData,
      'Data': CIcons.dataSet,
      'Kafka': CIcons.flowStreamReference,
      'Collection': CIcons.folder,
      'Environment': CIcons.settings,
      'Document': CIcons.document,
      'Spec': CIcons.code,
      'Mock': CIcons.modelAlt,
      'Mock Server': CIcons.dataBase,
      'Monitor': CIcons.chartLine,
      'Webhook': CIcons.events,
      'Flow': CIcons.flow,
      'Dataset': CIcons.dataTable,
      'AI Toolset': CIcons.toolBox,
    };

    for (final MapEntry(:key, :value) in entries.entries) {
      final row = find.ancestor(of: find.text(key), matching: find.byType(Row));
      expect(
        find.descendant(of: row, matching: find.byIcon(value)),
        findsOneWidget,
        reason: key,
      );
    }
  });
}
