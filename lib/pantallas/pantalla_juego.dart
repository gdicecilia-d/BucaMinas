// pantalla del juego sin lógica
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaJuego extends StatefulWidget {
  final String dificultad;
  const PantallaJuego({super.key, required this.dificultad});

  @override
  State<PantallaJuego> createState() => _PantallaJuegoState();
}

class _PantallaJuegoState extends State<PantallaJuego> {
  int _minasRestantes = 0;
  int _intentos = 0;
  bool _juegoTerminado = false;
  String _estiloNumeros = 'clasico';
  String _tema = 'auto';

  @override
  void initState() {
    super.initState();
    _cargarConfiguracion();
  }

  Future<void> _cargarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _estiloNumeros = prefs.getString('estiloNumeros') ?? 'clasico';
      _tema = prefs.getString('tema') ?? 'auto';
      _minasRestantes = widget.dificultad == 'facil' ? 10 : widget.dificultad == 'medio' ? 20 : 30;
    });
  }

  void _reiniciarJuego() {
    setState(() {
      _minasRestantes = widget.dificultad == 'facil' ? 10 : widget.dificultad == 'medio' ? 20 : 30;
      _intentos = 0;
      _juegoTerminado = false;
    });
  }

  void _salirAlMenu() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final brightness = MediaQuery.of(context).platformBrightness;
    final bool esModoOscuro = _tema == 'oscuro' || (_tema == 'auto' && brightness == Brightness.dark);
    
    int tamanoTablero = widget.dificultad == 'facil' ? 6 : widget.dificultad == 'medio' ? 8 : 10;
    
    // tamaño de casilla adaptativo
    double maxAnchoTablero = screenSize.width * 0.85;
    double maxAltoDisponible = screenSize.height * 0.6;
    double casillaSize = (maxAnchoTablero / tamanoTablero).clamp(25, 55);
    
    double altoTablero = casillaSize * tamanoTablero;
    if (altoTablero > maxAltoDisponible) {
      casillaSize = maxAltoDisponible / tamanoTablero;
    }
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagenes/fondo_principal.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Botón volver
            Positioned(
              top: 20,
              left: 20,
              child: _BotonVolver(onTap: _salirAlMenu),
            ),
            
            // Contenido centrado 
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Panel de control
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFc957d2), width: 1.8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFc957d2).withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Minas restantes
                        Row(
                          children: [
                            Image.asset('assets/imagenes/mina.png', width: 28, height: 28),
                            const SizedBox(width: 8),
                            Text(
                              '$_minasRestantes',
                              style: GoogleFonts.pressStart2p(fontSize: 16, color: const Color(0xFFc957d2)),
                            ),
                          ],
                        ),
                        
                        // Separador
                        Container(
                          width: 1,
                          height: 28,
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          color: const Color(0xFFc957d2).withOpacity(0.4),
                        ),
                        
                        // Intentos
                        Text(
                          '$_intentos',
                          style: GoogleFonts.pressStart2p(fontSize: 16, color: const Color(0xFFc957d2)),
                        ),
                        
                        // Separador
                        Container(
                          width: 1,
                          height: 28,
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          color: const Color(0xFFc957d2).withOpacity(0.4),
                        ),
                        
                        // Botón reiniciar
                        _BotonReiniciar(onTap: _reiniciarJuego),
                      ],
                    ),
                  ),
                  
                  // Tablero borde neon 
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFc957d2), width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFc957d2).withOpacity(0.4),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      width: casillaSize * tamanoTablero,
                      height: casillaSize * tamanoTablero,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: tamanoTablero,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: tamanoTablero * tamanoTablero,
                        itemBuilder: (context, index) {
                          return _Casilla(
                            casillaSize: casillaSize,
                            tamanoTablero: tamanoTablero,
                            estiloNumeros: _estiloNumeros,
                            esModoOscuro: esModoOscuro,
                            onTap: () {
                              if (_juegoTerminado) return;
                            },
                            onLongPress: () {
                              if (_juegoTerminado) return;
                            },
                          );
                        },
                      ),
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

// Casilla
class _Casilla extends StatefulWidget {
  final double casillaSize;
  final int tamanoTablero;
  final String estiloNumeros;
  final bool esModoOscuro;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _Casilla({
    required this.casillaSize,
    required this.tamanoTablero,
    required this.estiloNumeros,
    required this.esModoOscuro,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<_Casilla> createState() => _CasillaState();
}

class _CasillaState extends State<_Casilla> {
  bool _revelada = false;
  bool _tieneBandera = false;
  int _numero = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () {
        setState(() {
          _tieneBandera = !_tieneBandera;
        });
        widget.onLongPress();
      },
      child: Container(
        width: widget.casillaSize,
        height: widget.casillaSize,
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: _revelada
              ? (_numero == -1 ? Colors.red[900] : (widget.esModoOscuro ? Colors.grey[350] : Colors.grey[200]))
              : (widget.esModoOscuro ? Colors.grey[800] : Colors.grey[300]),
          border: Border.all(
            color: _revelada ? Colors.white24 : (widget.esModoOscuro ? Colors.grey[600]! : Colors.grey[400]!),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: _revelada ? _buildContenidoRevelado() : _buildContenidoTapado(),
        ),
      ),
    );
  }

  Widget _buildContenidoTapado() {
    if (_tieneBandera) {
      return Image.asset('assets/imagenes/bandera.png', width: widget.casillaSize * 0.5, height: widget.casillaSize * 0.5);
    }
    return const SizedBox.shrink();
  }

  Widget _buildContenidoRevelado() {
    if (_numero == -1) {
      return Image.asset('assets/imagenes/mina.png', width: widget.casillaSize * 0.5, height: widget.casillaSize * 0.5);
    } else if (_numero == 0) {
      return const SizedBox.shrink();
    } else {
      return Text(
        '$_numero',
        style: GoogleFonts.pressStart2p(
          fontSize: widget.casillaSize * 0.35,
          color: _obtenerColorNumero(_numero),
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Color _obtenerColorNumero(int numero) {
    switch (widget.estiloNumeros) {
      case 'colorido':
        switch (numero) {
          case 1: return const Color(0xFF00BFFF);
          case 2: return const Color(0xFF32CD32);
          case 3: return const Color(0xFFFF4500);
          case 4: return const Color(0xFF8A2BE2);
          case 5: return const Color(0xFFFF1493);
          case 6: return const Color(0xFF20B2AA);
          default: return Colors.white;
        }
      case 'retro':
        switch (numero) {
          case 1: return const Color(0xFF88A2C0);
          case 2: return const Color(0xFF8FBC8F);
          case 3: return const Color(0xFFCD5C5C);
          case 4: return const Color(0xFFB19CD9);
          case 5: return const Color(0xFFDDA0DD);
          case 6: return const Color(0xFF9ACD32);
          default: return Colors.white;
        }
      case 'minimalista':
        return widget.esModoOscuro ? Colors.white : Colors.black;
      default:
        switch (numero) {
          case 1: return Colors.blue;
          case 2: return Colors.green;
          case 3: return Colors.red;
          case 4: return const Color(0xFF6ba8de);
          case 5: return const Color(0xFFc957d2);
          case 6: return const Color(0xFFfa798a);
          default: return Colors.white;
        }
    }
  }
}

// Botón volver 
class _BotonVolver extends StatefulWidget {
  final VoidCallback onTap;
  const _BotonVolver({required this.onTap});

  @override
  State<_BotonVolver> createState() => _BotonVolverState();
}

class _BotonVolverState extends State<_BotonVolver> {
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
          duration: const Duration(milliseconds: 150),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFc957d2), width: _hover ? 3 : 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFc957d2).withOpacity(_hover ? 0.7 : 0.3),
                blurRadius: _hover ? 15 : 8,
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

// Botón Reiniciar
class _BotonReiniciar extends StatefulWidget {
  final VoidCallback onTap;
  const _BotonReiniciar({required this.onTap});

  @override
  State<_BotonReiniciar> createState() => _BotonReiniciarState();
}

class _BotonReiniciarState extends State<_BotonReiniciar> {
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
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFc957d2), width: _hover ? 1.5 : 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFc957d2).withOpacity(_hover ? 0.5 : 0.2),
                blurRadius: _hover ? 8 : 4,
              ),
            ],
          ),
          child: Text(
            '↻',
            style: GoogleFonts.pressStart2p(fontSize: 16, color: const Color(0xFFc957d2)),
          ),
        ),
      ),
    );
  }
}