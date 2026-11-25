import 'package:apidash/core/carbon.dart';
import 'package:apidash/features/workspace/screen/work_space.dart';
import 'package:apidash/features/workspace/widgets/work_space_collections_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('resize handle reports horizontal drag', (tester) async {
    var totalDrag = 0.0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CResizeHandle(
            direction: CResizeHandleDirection.horizontal,
            onDrag: (delta) => totalDrag += delta,
          ),
        ),
      ),
    );

    await tester.drag(find.byType(CResizeHandle), const Offset(40, 0));
    await tester.pump();

    expect(totalDrag, greaterThan(0));
  });

  testWidgets('shell navigation panel can be resized', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CUiShell(
          props: CUiShellProps(
            items: const [CUiShellNavItem(label: 'Home', icon: Icons.home)],
            selectedIndex: 0,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );

    final before = tester
        .widget<CUiShellLeftPanel>(find.byType(CUiShellLeftPanel))
        .width;

    await tester.drag(find.byType(CResizeHandle), const Offset(60, 0));
    await tester.pump();

    final after = tester
        .widget<CUiShellLeftPanel>(find.byType(CUiShellLeftPanel))
        .width;
    expect(after, greaterThan(before));
  });

  testWidgets('workspace panels use a fixed layout', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: WorkSpace()));

    expect(find.byType(CResizeHandle), findsNothing);

    double panelWidth() => tester
        .widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(WorkSpaceCollectionsPanel),
                matching: find.byType(SizedBox),
              )
              .first,
        )
        .width!;

    final before = panelWidth();
    expect(before, greaterThanOrEqualTo(300));

    await tester.drag(
      find.byType(WorkSpaceCollectionsPanel),
      const Offset(60, 0),
    );
    await tester.pump();

    expect(panelWidth(), before);
  });
}
