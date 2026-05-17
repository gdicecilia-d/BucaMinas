import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importar pantallas
import 'pantallas/pantalla_carga.dart';
import 'pantallas/pantalla_inicio.dart';
import 'pantallas/pantalla_configuracion.dart';
import 'pantallas/pantalla_marcadores.dart';
import 'pantallas/pantalla_instrucciones.dart';
import 'pantallas/pantalla_creditos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar las preferencias guardadas del usuario 
  final prefs = await SharedPreferences.getInstance();
  final temaGuardado = prefs.getString('tema') ?? 'auto';
  
  // Iniciar la app con la configuración cargada
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
      
      // Configuración de temas claro y oscuro
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      
      // Seleccionar el tema según lo guardado por el usuario
      themeMode: temaInicial == 'claro'
          ? ThemeMode.light
          : temaInicial == 'oscuro'
              ? ThemeMode.dark
              : ThemeMode.system,  // usa el tema del sistema
      
      initialRoute: '/',  // Pantalla inicial
      routes: {
        '/': (context) => const PantallaCarga(),
        '/inicio': (context) => const PantallaInicio(),
        '/configuracion': (context) => const PantallaConfiguracion(),
        '/marcadores': (context) => const PantallaMarcadores(),
        '/instrucciones': (context) => const PantallaInstrucciones(),
        '/creditos': (context) => const PantallaCreditos(),
      },
    );
  }
}