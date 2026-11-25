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

  testWidgets('workspace collections panel can be resized', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WorkSpace()));

    final before = tester
        .ancestorOf<SizedBox>(find.byType(WorkSpaceCollectionsPanel))!
        .width;

    await tester.drag(find.byType(CResizeHandle).first, const Offset(60, 0));
    await tester.pump();

    final after = tester
        .ancestorOf<SizedBox>(find.byType(WorkSpaceCollectionsPanel))!
        .width;
    expect(after, greaterThan(before));
  });
}
