import 'package:apidash/core/carbon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('breadcrumb colors follow the active theme', (tester) async {
    final controller = AppThemeController();

    await tester.pumpWidget(
      AppThemeScope(
        controller: controller,
        child: ValueListenableBuilder<AppThemeMode>(
          valueListenable: controller,
          builder: (context, mode, _) {
            return MaterialApp(
              theme: AppTheme.themeDataFor(mode),
              home: Scaffold(
                body: CBreadcrumb(
                  children: [
                    CBreadcrumbItem(
                      onTap: () {},
                      child: const Text('Workspace'),
                    ),
                    CBreadcrumbItem(
                      isCurrentPage: true,
                      onTap: () {},
                      child: const Text('Request'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    Color itemBackground(String label) {
      final container = tester.widget<AnimatedContainer>(
        find
            .ancestor(
              of: find.text(label),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      return (container.decoration! as BoxDecoration).color!;
    }

    Color itemTextColor(String label) {
      final style = tester.widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text(label),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );
      return style.style.color!;
    }

    Color slashColor() => tester.widget<Text>(find.text('/')).style!.color!;

    void expectThemeColors(AppThemeTokens tokens) {
      expect(itemBackground('Workspace'), tokens.background);
      expect(itemTextColor('Workspace'), tokens.linkPrimary);
      expect(itemTextColor('Request'), tokens.textPrimary);
      expect(slashColor(), tokens.textPrimary);
    }

    expectThemeColors(AppThemeTokens.white());

    controller.setThemeMode(AppThemeMode.gray100);
    await tester.pumpAndSettle();

    expectThemeColors(AppThemeTokens.gray100());
  });
}
