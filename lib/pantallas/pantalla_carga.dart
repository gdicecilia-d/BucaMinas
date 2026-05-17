// Splash Screen 
import 'package:flutter/material.dart';

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});

  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _logoAnimationController;
  double _progress = 0.0;
  
  // colores para la barra de carga
  final List<Color> coloresCarga = [
    const Color(0xFFc957d2),  // Morado
    const Color(0xFF6ba8de),  // Azul
    const Color(0xFFfa798a),  // Rosado
    const Color(0xFFf93cc7),  // Rosa fuerte
    const Color(0xFFfdc445),  // Amarillo
  ];
  
  static const int tiempoCargaSegundos = 8;  

  @override
  void initState() {
    super.initState();
    
    // Animación de la barra de progreso
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: tiempoCargaSegundos),
    );
    
    _progressController.addListener(() {
      setState(() {
        _progress = _progressController.value;
      });
    });
    
    _progressController.forward();
    
    // Animación CONSTANTE del logo (respira)
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      reverseDuration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Navegar al menú 
    _irAlMenu();
  }
  
  void _irAlMenu() async {
    await Future.delayed(const Duration(seconds: tiempoCargaSegundos));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/inicio');
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtener tamaño de la pantalla
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagenes/fondo_principal.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Logo con animacion 
            Expanded(
              flex: 8,
              child: Center(
                child: AnimatedBuilder(
                  animation: _logoAnimationController,
                  builder: (context, child) {
                    final scale = 0.95 + (_logoAnimationController.value * 0.1);
                    return Transform.scale(
                      scale: scale,
                      child: Image.asset(
                        'assets/imagenes/logo.png',
                        width: screenSize.width * 0.8,
                        height: screenSize.height * 0.6,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Barra de carga
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: 350 * _progress,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: coloresCarga,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}