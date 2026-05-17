// Menú Principal
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> with TickerProviderStateMixin {
  AnimationController? _logoAnimationController;
  bool _animacionesActivadas = true;
  
  @override
  void initState() {
    super.initState();
    _cargarConfiguracion();
  }
  
  Future<void> _cargarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _animacionesActivadas = prefs.getBool('animaciones') ?? true;
    });
    
    _logoAnimationController?.dispose();
    _logoAnimationController = null;
    
    if (_animacionesActivadas) {
      _logoAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
        reverseDuration: const Duration(milliseconds: 2000),
      )..repeat(reverse: true);
    }
    
    if (mounted) setState(() {});
  }
  
  @override
  void dispose() {
    _logoAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    final bool esMovil = screenSize.width < 600;
    double anchoBoton = esMovil ? (screenSize.width * 0.4).clamp(130.0, 180.0) : 250;
    double alturaBoton = esMovil ? anchoBoton * 0.45 : 100;
    double fontSizeBoton = esMovil ? 10 : 14;
    double espacioEntreBotones = esMovil ? 12 : 30;
    double espacioEntreFilas = esMovil ? 15 : 25;
    
    return Scaffold(
      // Fondo 
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagenes/fondo_principal.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              // asegura que el contenido tenga al menos el alto de la pantalla
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  
                  // Logo
                  (_animacionesActivadas && _logoAnimationController != null)
                      ? AnimatedBuilder(
                          animation: _logoAnimationController!,
                          builder: (context, child) {
                            final scale = 0.97 + (_logoAnimationController!.value * 0.06);
                            return Transform.scale(
                              scale: scale,
                              child: Center(
                                child: Image.asset(
                                  'assets/imagenes/logo.png',
                                  width: screenSize.width * 0.7,
                                  height: screenSize.height * 0.4,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Image.asset(
                            'assets/imagenes/logo.png',
                            width: screenSize.width * 0.7,
                            height: screenSize.height * 0.4,
                            fit: BoxFit.contain,
                          ),
                        ),
                  
                  const SizedBox(height: 20),
                  
                  // Botones
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _BotonNeon(
                              texto: 'Jugar',
                              color: const Color(0xFFc957d2),
                              ancho: anchoBoton,
                              altura: alturaBoton,
                              fontSize: fontSizeBoton,
                              onTap: () async {
                                final prefs = await SharedPreferences.getInstance();
                                final dificultad = prefs.getString('dificultad') ?? 'facil';
                                Navigator.pushNamed(context, '/juego', arguments: dificultad);
                              },
                            ),
                            SizedBox(width: espacioEntreBotones),
                            _BotonNeon(
                              texto: 'Máximas\nPuntuaciones',
                              color: const Color(0xFF6ba8de),
                              ancho: anchoBoton,
                              altura: alturaBoton,
                              fontSize: fontSizeBoton,
                              onTap: () async {
                                await Navigator.pushNamed(context, '/marcadores');
                                _cargarConfiguracion();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: espacioEntreFilas),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _BotonNeon(
                              texto: 'Configuración',
                              color: const Color(0xFFfa798a),
                              ancho: anchoBoton,
                              altura: alturaBoton,
                              fontSize: fontSizeBoton,
                              onTap: () async {
                                await Navigator.pushNamed(context, '/configuracion');
                                _cargarConfiguracion();
                              },
                            ),
                            SizedBox(width: espacioEntreBotones),
                            _BotonNeon(
                              texto: 'Instrucciones',
                              color: const Color(0xFFf93cc7),
                              ancho: anchoBoton,
                              altura: alturaBoton,
                              fontSize: fontSizeBoton,
                              onTap: () async {
                                await Navigator.pushNamed(context, '/instrucciones');
                                _cargarConfiguracion();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _BotonCreditosNeon(
        onTap: () async {
          await Navigator.pushNamed(context, '/creditos');
          _cargarConfiguracion();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// Boton neon 
class _BotonNeon extends StatefulWidget {
  final String texto;
  final Color color;
  final double ancho;
  final double altura;
  final double fontSize;
  final VoidCallback onTap;

  const _BotonNeon({
    required this.texto,
    required this.color,
    required this.ancho,
    required this.altura,
    required this.fontSize,
    required this.onTap,
  });

  @override
  State<_BotonNeon> createState() => _BotonNeonState();
}

class _BotonNeonState extends State<_BotonNeon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,  
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.ancho,
          height: widget.altura,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.color,
              width: _hover ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_hover ? 0.7 : 0.3),
                blurRadius: _hover ? 18 : 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.texto,
              textAlign: TextAlign.center,
              style: GoogleFonts.pressStart2p(
                fontSize: widget.fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Boton créditos
class _BotonCreditosNeon extends StatefulWidget {
  final VoidCallback onTap;

  const _BotonCreditosNeon({required this.onTap});

  @override
  State<_BotonCreditosNeon> createState() => _BotonCreditosNeonState();
}

class _BotonCreditosNeonState extends State<_BotonCreditosNeon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool esMovil = screenSize.width < 600;
    double tamanioCredito = esMovil ? 50 : 65;
    double iconoSize = esMovil ? 26 : 32;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,  
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: tamanioCredito,
          height: tamanioCredito,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFfdc445),
              width: _hover ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFfdc445).withOpacity(_hover ? 0.7 : 0.3),
                blurRadius: _hover ? 15 : 8,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.people,
              color: Colors.white,
              size: iconoSize,
            ),
          ),
        ),
      ),
    );
  }
}