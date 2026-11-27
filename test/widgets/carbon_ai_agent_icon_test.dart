import 'package:apidash/core/components/icon/ai_agent_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' as flutter_svg;
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Carbon AiAgent icon renders from the Carbon SVG source', (
    tester,
  ) async {
    const color = Color(0xFF123456);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: CAiAgentIcon(color: color)),
        ),
      ),
    );

    final svg = tester.widget<flutter_svg.SvgPicture>(
      find.byType(flutter_svg.SvgPicture),
    );
    expect(svg.width, 24);
    expect(svg.height, 24);
    expect(svg.colorFilter, ColorFilter.mode(color, BlendMode.srcIn));
  });
}
