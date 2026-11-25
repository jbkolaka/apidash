import 'package:apidash/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ApiDashApp follows device brightness changes', (tester) async {
    final dispatcher = tester.binding.platformDispatcher;
    final originalBrightness = dispatcher.platformBrightness;
    addTearDown(() {
      dispatcher.platformBrightnessTestValue = originalBrightness;
    });

    dispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpWidget(const ProviderScope(child: ApiDashApp()));

    Brightness currentBrightness() =>
        tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!.brightness;

    expect(currentBrightness(), Brightness.light);

    dispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pump();
    expect(currentBrightness(), Brightness.dark);

    dispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pump();
    expect(currentBrightness(), Brightness.light);
  });
}
