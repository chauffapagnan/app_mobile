import 'package:chauffagecanette/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chauffagecanette/mqtt/mqtt_connect.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Attendre que l'initialisation MQTT soit terminée
    await MQTTConnect.ensureInitialized();

    // Attendre que tout soit rendu
    await tester.pumpAndSettle();

    // Vérifiez que notre compteur commence à 0.0.
    expect(find.text('0.0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Vérifiez que notre compteur a été incrémenté.
    expect(find.text('0.0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
