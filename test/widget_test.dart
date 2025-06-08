// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pit_stop/main.dart';

void main() {
  testWidgets('Pit Stop app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: PitStopApp()));

    // Verify that the app title is displayed.
    expect(find.text('PIT STOP PIZZARIA'), findsOneWidget);

    // Verify that the main message is displayed.
    expect(find.text('Sistema funcionando!'), findsOneWidget);

    // Verify that the subtitle is displayed.
    expect(find.text('Gestão de Pizzaria Profissional'), findsOneWidget);

    // Verify that the floating action button is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Novo Pedido'), findsOneWidget);

    // Verify that buttons are present.
    expect(find.text('Acessar Dashboard'), findsOneWidget);
    expect(find.text('Configurações'), findsOneWidget);
  });

  testWidgets('Button interaction test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: PitStopApp()));

    // Tap on "Acessar Dashboard" button.
    await tester.tap(find.text('Acessar Dashboard'));
    await tester.pump();

    // Tap on "Configurações" button.
    await tester.tap(find.text('Configurações'));
    await tester.pump();

    // Tap on floating action button.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // All taps should complete without errors
  });
}
