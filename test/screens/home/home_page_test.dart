import 'package:apidash/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('new home page renders', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ApiDashApp()));

    expect(find.text('A new start'), findsOneWidget);
    expect(find.text('Getting started'), findsOneWidget);
    expect(find.text('Create request'), findsOneWidget);
    expect(find.text('Workspace name'), findsOneWidget);
  });

  testWidgets('ui shell left nav items render', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ApiDashApp()));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Workspace'), findsOneWidget);
    expect(find.text('Application inventory'), findsOneWidget);
    expect(find.text('Public API network'), findsOneWidget);
    expect(find.text('Private API network'), findsOneWidget);
    expect(find.text('Search'), findsNothing);
  });
}
