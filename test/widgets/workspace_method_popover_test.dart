import 'package:apidash/core/carbon.dart';
import 'package:apidash/features/workspace/widgets/work_space_config_tabs.dart';
import 'package:apidash/features/workspace/widgets/work_space_header.dart';
import 'package:apidash/features/workspace/widgets/work_space_model.dart';
import 'package:apidash/features/workspace/widgets/work_space_url_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  testWidgets('HTTP method popover selects a method', (tester) async {
    String? selectedMethod;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorkSpaceUrlBar(
            request: const WorkspaceRequest(
              id: 'req-test',
              name: 'Test',
              method: 'GET',
              url: 'https://example.com',
            ),
            loading: false,
            onMethodChanged: (method) => selectedMethod = method,
            onUrlChanged: (_) {},
            onSend: () {},
            onSave: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.byType(CPopover));
    await tester.pumpAndSettle();

    expect(find.text('POST'), findsOneWidget);
    expect(find.text('OPTIONS'), findsOneWidget);

    await tester.tap(find.text('POST'));
    await tester.pumpAndSettle();

    expect(selectedMethod, 'POST');
  });

  testWidgets('URL field stays borderless when focused', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorkSpaceUrlBar(
            request: const WorkspaceRequest(
              id: 'req-test',
              name: 'Test',
              method: 'GET',
              url: 'https://example.com',
            ),
            loading: false,
            onMethodChanged: (_) {},
            onUrlChanged: (_) {},
            onSend: () {},
            onSave: () {},
          ),
        ),
      ),
    );

    final carbonField = tester.widget<CTextField>(find.byType(CTextField));
    expect(carbonField.hideBorder, isTrue);

    await tester.tap(find.byType(TextField));
    await tester.pump();

    final fieldFinder = find.byType(TextField);
    final field = tester.widget<TextField>(fieldFinder);
    expect(field.decoration?.border, InputBorder.none);
    expect(field.decoration?.filled, isTrue);

    final fieldRect = tester.getRect(fieldFinder);
    final textRect = tester.getRect(find.text('https://example.com'));
    expect((textRect.center.dy - fieldRect.center.dy).abs(), lessThan(2));
  });

  testWidgets('config tabs use the requested order', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorkSpaceConfigTabs(
            request: workspaceSeedRequests().first,
            onQueryParamsChanged: (_) {},
            onHeadersChanged: (_) {},
            onAuthTypeChanged: (_) {},
            onBearerTokenChanged: (_) {},
            onBodyTypeChanged: (_) {},
            onBodyChanged: (_) {},
          ),
        ),
      ),
    );

    for (final label in [
      'Docs',
      'Params',
      'Authorization',
      'Headers (7)',
      'Body',
      'Scripts',
      'Settings',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }

    final dividerFinder = find.byType(VerticalDivider);
    expect(dividerFinder, findsOneWidget);
    expect(tester.getRect(dividerFinder).height, greaterThan(400));

    final authHint = tester.widget<RichText>(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains(
              'The authorization data will be automatically generated',
            ),
      ),
    );
    final authSpan = authHint.text as TextSpan;
    expect(authSpan.children, hasLength(2));
    final authLink = authSpan.children!.last as TextSpan;
    expect(authLink.text, 'Learn more about authorization ↗');
    expect(authLink.recognizer, isNotNull);

    await tester.tap(find.text('Scripts'));
    await tester.pump();

    expect(find.text('Pre-request'), findsOneWidget);
    expect(find.text('Post-response'), findsOneWidget);
  });

  testWidgets('bearer auth shows a labeled token field', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorkSpaceConfigTabs(
            request: workspaceSeedRequests().first.copyWith(
              authType: WorkspaceAuthType.bearerToken,
              bearerToken: 'token-123',
            ),
            onQueryParamsChanged: (_) {},
            onHeadersChanged: (_) {},
            onAuthTypeChanged: (_) {},
            onBearerTokenChanged: (_) {},
            onBodyTypeChanged: (_) {},
            onBodyChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Token'), findsOneWidget);
    expect(find.text('token-123'), findsOneWidget);
  });

  testWidgets('workspace header uses breadcrumbs and window controls', (
    tester,
  ) async {
    var backTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorkSpaceHeader(
            environment: null,
            environments: const ['Production'],
            onEnvironmentChanged: (_) {},
            onBack: () => backTapped = true,
            collectionName: 'Core Services API',
            requestName: 'Get Users List',
          ),
        ),
      ),
    );

    expect(find.text('My Workspace'), findsOneWidget);
    expect(find.text('Core Services API'), findsOneWidget);
    expect(find.text('Get Users List'), findsOneWidget);
    expect(find.byIcon(CIcons.settings), findsNothing);
    expect(find.byIcon(CIcons.arrowLeft), findsNothing);
    expect(find.byType(WindowCaptionButton), findsNWidgets(3));

    await tester.tap(find.text('My Workspace'));
    await tester.pump();

    expect(backTapped, isTrue);
  });
}
