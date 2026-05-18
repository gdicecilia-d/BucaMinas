// Pantalla de Juego 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logic/minesweeper_controller.dart';
import '../logic/board_models.dart';

class PantallaJuego extends StatefulWidget {
  final String dificultad;
  const PantallaJuego({super.key, required this.dificultad});

  @override
  State<PantallaJuego> createState() => _PantallaJuegoState();
}

class _PantallaJuegoState extends State<PantallaJuego> {
  late MinesweeperController _controller;
  bool _esModoOscuro = true;

  @override
  void initState() {
    super.initState();
    _controller = MinesweeperController();
    _cargarTema();
    _cargarEstiloNumeros();
    
    GameDifficulty dificultadEnum;
    switch (widget.dificultad) {
      case 'medio':
        dificultadEnum = GameDifficulty.medium;
        break;
      case 'dificil':
        dificultadEnum = GameDifficulty.hard;
        break;
      default:
        dificultadEnum = GameDifficulty.easy;
    }
    
    _controller.startGame(dificultadEnum);
    
    _controller.setOnGameWon(_mostrarDialogoVictoria);
    _controller.setOnGameLost(_mostrarDialogoDerrota);
  }

  Future<void> _cargarTema() async {
    final prefs = await SharedPreferences.getInstance();
    final tema = prefs.getString('tema') ?? 'auto';
    final brightness = MediaQuery.of(context).platformBrightness;
    setState(() {
      _esModoOscuro = tema == 'oscuro' || (tema == 'auto' && brightness == Brightness.dark);
    });
  }

  Future<void> _cargarEstiloNumeros() async {
    final prefs = await SharedPreferences.getInstance();
    final estilo = prefs.getString('estiloNumeros') ?? 'clasico';
    NumberStyle estiloEnum;
    switch (estilo) {
      case 'colorido':
        estiloEnum = NumberStyle.colorido;
        break;
      case 'retro':
        estiloEnum = NumberStyle.retro;
        break;
      case 'minimalista':
        estiloEnum = NumberStyle.minimalista;
        break;
      default:
        estiloEnum = NumberStyle.clasico;
    }
    await _controller.updateNumberStyle(estiloEnum);
  }

  void _mostrarDialogoVictoria(int tiempo, bool esNuevoRecord) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00FF00), width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FF00).withOpacity(0.6),
                  blurRadius: 25,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, color: Color(0xFFfdc445), size: 60),
                const SizedBox(height: 15),
                Text('¡VICTORIA!', style: GoogleFonts.silkscreen(fontSize: 20, color: const Color(0xFF00FF00))),
                const SizedBox(height: 10),
                Text('Tiempo: ${tiempo ~/ 60}:${(tiempo % 60).toString().padLeft(2, '0')}',
                  style: GoogleFonts.vt323(fontSize: 16, color: Colors.white70)),
                if (esNuevoRecord) ...[
                  const SizedBox(height: 8),
                  Text('✨ ¡NUEVO RÉCORD! ✨',
                    style: GoogleFonts.silkscreen(fontSize: 12, color: const Color(0xFFfdc445))),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BotonDialogo(texto: 'REINICIAR', color: const Color(0xFF6ba8de), onTap: () {
                      Navigator.pop(context);
                      _controller.startGame(_controller.difficulty);
                    }),
                    const SizedBox(width: 15),
                    _BotonDialogo(texto: 'SALIR', color: const Color(0xFFfa798a), onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarDialogoDerrota() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFF0000), width: 3),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFF0000).withOpacity(0.6), blurRadius: 25, spreadRadius: 3),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF0000), size: 60),
                const SizedBox(height: 15),
                Text('¡EXPLOTASTE!', style: GoogleFonts.silkscreen(fontSize: 18, color: const Color(0xFFFF0000))),
                const SizedBox(height: 10),
                Text('Una mina te ha detonado', style: GoogleFonts.vt323(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BotonDialogo(texto: 'REINICIAR', color: const Color(0xFF6ba8de), onTap: () {
                      Navigator.pop(context);
                      _controller.startGame(_controller.difficulty);
                    }),
                    const SizedBox(width: 15),
                    _BotonDialogo(texto: 'SALIR', color: const Color(0xFFfa798a), onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _salirAlMenu() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    int tamanoTablero = _controller.difficulty.rows;
    
    double maxAnchoTablero = screenSize.width * 0.85;
    double maxAltoDisponible = screenSize.height * 0.55;
    double casillaSize = (maxAnchoTablero / tamanoTablero).clamp(25, 55);
    
    double altoTablero = casillaSize * tamanoTablero;
    if (altoTablero > maxAltoDisponible) casillaSize = maxAltoDisponible / tamanoTablero;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/imagenes/fondo_principal.png'), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Positioned(top: 20, left: 20, child: _BotonVolver(onTap: _salirAlMenu)),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: _esModoOscuro ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFc957d2), width: 1.8),
                    ),
                    child: ListenableBuilder(
                      listenable: _controller,
                      builder: (context, _) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(children: [
                            Image.asset('assets/imagenes/mina.png', width: 28, height: 28),
                            const SizedBox(width: 8),
                            Text('${_controller.remainingMines}',
                                style: GoogleFonts.pressStart2p(fontSize: 16, color: const Color(0xFFc957d2))),
                          ]),
                          Container(width: 1, height: 28, margin: const EdgeInsets.symmetric(horizontal: 18),
                              color: const Color(0xFFc957d2).withOpacity(0.4)),
                          Text('${_controller.elapsedTime}',
                              style: GoogleFonts.pressStart2p(fontSize: 16, color: const Color(0xFFc957d2))),
                          Container(width: 1, height: 28, margin: const EdgeInsets.symmetric(horizontal: 18),
                              color: const Color(0xFFc957d2).withOpacity(0.4)),
                          _BotonReiniciar(onTap: () => _controller.startGame(_controller.difficulty)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _esModoOscuro ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFc957d2), width: 2.5),
                    ),
                    child: Container(
                      width: casillaSize * tamanoTablero,
                      height: casillaSize * tamanoTablero,
                      child: ListenableBuilder(
                        listenable: _controller,
                        builder: (context, _) => GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: tamanoTablero,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: tamanoTablero * tamanoTablero,
                          itemBuilder: (context, index) {
                            int fila = index ~/ tamanoTablero;
                            int columna = index % tamanoTablero;
                            final cell = _controller.board[fila][columna];
                            return _Casilla(
                              casillaSize: casillaSize,
                              cell: cell,
                              estiloNumeros: _controller.currentNumberStyle.name,
                              esModoOscuro: _esModoOscuro,
                              onTap: () => _controller.tapCell(fila, columna),
                              onLongPress: () => _controller.flagCell(fila, columna),  // Tap largo 
                              onSecondaryTap: () => _controller.flagCell(fila, columna), // Click derecho 
                            );
                          },
                        ),
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
class _Casilla extends StatelessWidget {
  final double casillaSize;
  final CellModel cell;
  final String estiloNumeros;
  final bool esModoOscuro;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onSecondaryTap;

  const _Casilla({
    required this.casillaSize,
    required this.cell,
    required this.estiloNumeros,
    required this.esModoOscuro,
    required this.onTap,
    required this.onLongPress,
    required this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,                    // Tap normal → revelar
      onLongPress: onLongPress,        // Tap largo → bandera 
      onSecondaryTap: onSecondaryTap,  // Click derecho → bandera 
      child: Container(
        width: casillaSize,
        height: casillaSize,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: cell.isRevealed
              ? (cell.hasMine ? Colors.red[900] : (esModoOscuro ? Colors.grey[350] : Colors.grey[200]))
              : (esModoOscuro ? Colors.grey[800] : Colors.grey[300]),
          border: Border.all(
            color: cell.isRevealed ? Colors.white24 : (esModoOscuro ? Colors.grey[600]! : Colors.grey[400]!),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: cell.isRevealed ? _buildContenidoRevelado() : _buildContenidoTapado(),
        ),
      ),
    );
  }

  Widget _buildContenidoTapado() {
    if (cell.isFlagged) {
      return Image.asset('assets/imagenes/bandera.png', width: casillaSize * 0.5, height: casillaSize * 0.5);
    }
    return const SizedBox.shrink();
  }

  Widget _buildContenidoRevelado() {
    if (cell.hasMine) {
      return Image.asset('assets/imagenes/mina.png', width: casillaSize * 0.5, height: casillaSize * 0.5);
    } else if (cell.adjacentMines == 0) {
      return const SizedBox.shrink();
    } else {
      return Text(
        '${cell.adjacentMines}',
        style: GoogleFonts.pressStart2p(
          fontSize: casillaSize * 0.35,
          color: _obtenerColorNumero(cell.adjacentMines),
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Color _obtenerColorNumero(int numero) {
    switch (estiloNumeros) {
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
        return esModoOscuro ? Colors.white : Colors.black;
      default: // clasico
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
          width: 50, height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7), shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFc957d2), width: _hover ? 3 : 2),
            boxShadow: [BoxShadow(color: const Color(0xFFc957d2).withOpacity(_hover ? 0.7 : 0.3), blurRadius: _hover ? 15 : 8)],
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
            color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFc957d2), width: _hover ? 1.5 : 1),
            boxShadow: [BoxShadow(color: const Color(0xFFc957d2).withOpacity(_hover ? 0.5 : 0.2), blurRadius: _hover ? 8 : 4)],
          ),
          child: Text('↻', style: GoogleFonts.pressStart2p(fontSize: 16, color: const Color(0xFFc957d2))),
        ),
      ),
    );
  }
}

// Botón diálogo
class _BotonDialogo extends StatefulWidget {
  final String texto;
  final Color color;
  final VoidCallback onTap;
  const _BotonDialogo({required this.texto, required this.color, required this.onTap});

  @override
  State<_BotonDialogo> createState() => _BotonDialogoState();
}

class _BotonDialogoState extends State<_BotonDialogo> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.color, width: _hover ? 2 : 1.5),
            boxShadow: [BoxShadow(color: widget.color.withOpacity(_hover ? 0.5 : 0.2), blurRadius: _hover ? 12 : 5)],
          ),
          child: Text(widget.texto, style: GoogleFonts.silkscreen(fontSize: 10, color: widget.color)),
        ),
      ),
    );
  }
}