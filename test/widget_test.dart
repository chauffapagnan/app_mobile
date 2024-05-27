
import 'package:chauffagecanette/components/def_temp_chauffage/TempChauffage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chauffagecanette/main.dart';
import 'package:chauffagecanette/mqtt/mqtt_connect.dart';
Future<void> _initializeData() async {
  await MQTTConnect.prepareMqttClient();
}
void main() {

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    print('Début du test');

    // Appeler la fonction pour préparer le client MQTT


    // Pump the widget tree with MyApp
    await tester.pumpWidget( ToggleButtons2());

    print('Widget MyApp pompé');

    // Wait for everything to settle.
    await tester.pumpAndSettle();

    // Verify that our counter starts at 0.0.
    expect(find.text('0.0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    print('Incrémentation effectuée');

    // Verify that our counter has been incremented.
    expect(find.text('0.0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    print('Fin du test');
  });
}
