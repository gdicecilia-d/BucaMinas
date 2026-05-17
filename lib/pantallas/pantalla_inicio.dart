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
    
    // Detener animación anterior si existe
    _logoAnimationController?.dispose();
    _logoAnimationController = null;
    
    // Iniciar nueva animación solo si está activada
    if (_animacionesActivadas) {
      _logoAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
        reverseDuration: const Duration(milliseconds: 2000),
      )..repeat(reverse: true);
    }
    
    // Forzar rebuild
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
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagenes/fondo_principal.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              
              // Logo con animación si está activada Y el controller existe
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Fila 1
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _BotonNeon(
                          texto: 'Jugar',
                          color: const Color(0xFFc957d2),
                          ancho: 250,
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final dificultad = prefs.getString('dificultad') ?? 'facil';
                            Navigator.pushNamed(context, '/juego', arguments: dificultad);
                          },
                        ),
                        const SizedBox(width: 30),
                        _BotonNeon(
                          texto: 'Máximas\nPuntuaciones',
                          color: const Color(0xFF6ba8de),
                          ancho: 250,
                          onTap: () async {
                            await Navigator.pushNamed(context, '/marcadores');
                            _cargarConfiguracion();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    
                    // Fila 2
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _BotonNeon(
                          texto: 'Configuración',
                          color: const Color(0xFFfa798a),
                          ancho: 250,
                          onTap: () async {
                            await Navigator.pushNamed(context, '/configuracion');
                            _cargarConfiguracion();
                          },
                        ),
                        const SizedBox(width: 30),
                        _BotonNeon(
                          texto: 'Instrucciones',
                          color: const Color(0xFFf93cc7),
                          ancho: 250,
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
            ],
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
  final VoidCallback onTap;

  const _BotonNeon({
    required this.texto,
    required this.color,
    required this.ancho,
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
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(25),
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
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.4,
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,  
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 65,
          height: 65,
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
          child: const Center(
            child: Icon(
              Icons.people,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}