import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buscaminas/pantallas/pantalla_carga.dart';

void main() {
  testWidgets('Pantalla de carga se construye sin errores', (WidgetTester tester) async {
    // Construir solo la pantalla de carga (no toda la app)
    await tester.pumpWidget(const MaterialApp(
      home: PantallaCarga(),
    ));
    
    // Verificar que existe el Scaffold
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
