import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

void main() {
  const icon = LucideIcons.activity;

  testWidgets('LucideIcons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Icon(LucideIcons.activity),
        ),
      ),
    );

    expect(find.byIcon(icon), findsOneWidget);
  });
}
