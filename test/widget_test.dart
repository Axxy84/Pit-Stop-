// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pit_stop/main.dart';

void main() {
  testWidgets('Pit Stop app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PitStopApp());

    // Verify that the app title is displayed.
    expect(find.text('🍕 Pit Stop Pizzaria'), findsOneWidget);

    // Verify that the dashboard is displayed.
    expect(find.text('Dashboard Operacional'), findsOneWidget);

    // Verify that the navigation bar is present.
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify that the floating action button is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Novo Pedido'), findsOneWidget);
  });

  testWidgets('Navigation between tabs test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PitStopApp());

    // Tap on "Pedidos" tab.
    await tester.tap(find.text('Pedidos'));
    await tester.pump();

    // Verify that we're on the orders page.
    expect(find.text('Gestão de Pedidos'), findsOneWidget);

    // Tap on "Produtos" tab.
    await tester.tap(find.text('Produtos'));
    await tester.pump();

    // Verify that we're on the products page.
    expect(find.text('Gestão de Produtos'), findsOneWidget);

    // Tap on "Config" tab.
    await tester.tap(find.text('Config'));
    await tester.pump();

    // Verify that we're on the settings page.
    expect(find.text('Configurações'), findsOneWidget);
  });
}
