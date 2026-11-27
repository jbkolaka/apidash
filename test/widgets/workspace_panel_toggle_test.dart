import 'package:apidash/core/carbon.dart';
import 'package:apidash/features/workspace/screen/work_space.dart';
import 'package:apidash/features/workspace/widgets/work_space_ai_shell.dart';
import 'package:apidash/features/workspace/widgets/work_space_collections_panel.dart';
import 'package:apidash/features/workspace/widgets/work_space_response_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('status bar icon toggles the collections panel', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: WorkSpace())),
    );

    expect(find.byType(WorkSpaceCollectionsPanel), findsOneWidget);

    final hideTooltip = find.byTooltip('Hide collections panel');
    expect(hideTooltip, findsOneWidget);
    expect(
      find.descendant(
        of: hideTooltip,
        matching: find.byIcon(CIcons.openPanelFilledLeft),
      ),
      findsOneWidget,
    );

    await tester.tap(hideTooltip);
    await tester.pump();

    expect(find.byType(WorkSpaceCollectionsPanel), findsNothing);

    final showTooltip = find.byTooltip('Show collections panel');
    expect(showTooltip, findsOneWidget);
    expect(
      find.descendant(
        of: showTooltip,
        matching: find.byIcon(CIcons.openPanelLeft),
      ),
      findsOneWidget,
    );

    await tester.tap(showTooltip);
    await tester.pump();

    expect(find.byType(WorkSpaceCollectionsPanel), findsOneWidget);
  });

  testWidgets('status bar icon toggles the response panel', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: WorkSpace())),
    );

    expect(find.byType(WorkSpaceResponseViewer), findsOneWidget);

    final hideTooltip = find.byTooltip('Hide response panel');
    expect(hideTooltip, findsOneWidget);
    expect(
      find.descendant(
        of: hideTooltip,
        matching: find.byIcon(CIcons.openPanelFilledBottom),
      ),
      findsOneWidget,
    );

    await tester.tap(hideTooltip);
    await tester.pump();

    expect(find.byType(WorkSpaceResponseViewer), findsNothing);

    final showTooltip = find.byTooltip('Show response panel');
    expect(showTooltip, findsOneWidget);
    expect(
      find.descendant(
        of: showTooltip,
        matching: find.byIcon(CIcons.openPanelBottom),
      ),
      findsOneWidget,
    );

    await tester.tap(showTooltip);
    await tester.pump();

    expect(find.byType(WorkSpaceResponseViewer), findsOneWidget);
  });

  testWidgets('AI agent icon toggles the right shell', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: WorkSpace())),
    );

    final aiAgentTooltip = find.byTooltip('AI agent');
    expect(aiAgentTooltip, findsOneWidget);
    expect(
      find.descendant(of: aiAgentTooltip, matching: find.byType(CAiAgentIcon)),
      findsOneWidget,
    );
    expect(find.byType(WorkSpaceAiShell), findsNothing);

    await tester.tap(aiAgentTooltip);
    await tester.pump();

    expect(find.byType(WorkSpaceAiShell), findsOneWidget);
    expect(
      find.byKey(const Key('workspace-ai-shell-resize-handle')),
      findsOneWidget,
    );

    final shellRect = tester.getRect(find.byType(WorkSpaceAiShell));
    expect(shellRect.right, closeTo(1400, 1));
    expect(shellRect.left, greaterThan(700));

    await tester.tap(find.byTooltip('Maximize AI shell'));
    await tester.pump();

    expect(find.byType(WorkSpaceCollectionsPanel), findsNothing);
    expect(
      tester.getRect(find.byType(WorkSpaceAiShell)).width,
      closeTo(1400, 1),
    );

    await tester.tap(find.byTooltip('Restore AI shell'));
    await tester.tap(find.byTooltip('Close AI shell'));
    await tester.pump();

    expect(find.byType(WorkSpaceAiShell), findsNothing);
  });
}
