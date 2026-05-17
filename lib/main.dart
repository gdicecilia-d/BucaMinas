import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pantallas/pantalla_carga.dart';
import 'pantallas/pantalla_inicio.dart';
import 'pantallas/pantalla_configuracion.dart';
import 'pantallas/pantalla_marcadores.dart';
import 'pantallas/pantalla_instrucciones.dart';
import 'pantallas/pantalla_creditos.dart';
import 'pantallas/pantalla_juego.dart';  // ← IMPORTAR

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final temaGuardado = prefs.getString('tema') ?? 'auto';
  runApp(MyApp(temaInicial: temaGuardado));
}

class MyApp extends StatelessWidget {
  final String temaInicial;
  const MyApp({super.key, required this.temaInicial});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: temaInicial == 'claro'
          ? ThemeMode.light
          : temaInicial == 'oscuro'
              ? ThemeMode.dark
              : ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const PantallaCarga(),
        '/inicio': (context) => const PantallaInicio(),
        '/configuracion': (context) => const PantallaConfiguracion(),
        '/marcadores': (context) => const PantallaMarcadores(),
        '/instrucciones': (context) => const PantallaInstrucciones(),
        '/creditos': (context) => const PantallaCreditos(),
        '/juego': (context) {
          final dificultad = ModalRoute.of(context)?.settings.arguments as String? ?? 'facil';
          return PantallaJuego(dificultad: dificultad);
        },
      },
    );
  }
}