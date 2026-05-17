import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logic/board_models.dart';
import '../logic/minesweeper_controller.dart';

class PantallaJuego extends StatefulWidget {
  final String dificultad;
  const PantallaJuego({super.key, required this.dificultad});

  @override
  State<PantallaJuego> createState() => _PantallaJuegoState();
}

class _PantallaJuegoState extends State<PantallaJuego> {
  late final MinesweeperController _controller;
  String _estiloNumeros = 'clasico';
  String _tema = 'auto';

  @override
  void initState() {
    super.initState();
    _controller = MinesweeperController();
    _iniciarJuego();
    _cargarConfiguracion();
  }
  
  GameDifficulty _obtenerDificultad() {
    switch (widget.dificultad) {
      case 'medio':
        return GameDifficulty.medium;
      case 'dificil':
        return GameDifficulty.hard;
      case 'facil':
      default:
        return GameDifficulty.easy;
    }
  }

  void _iniciarJuego() {
    _controller.startGame(_obtenerDificultad());
  }

  Future<void> _cargarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _estiloNumeros = prefs.getString('estiloNumeros') ?? 'clasico';
      _tema = prefs.getString('tema') ?? 'auto';
    });
  }

  void _salirAlMenu() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final brightness = MediaQuery.of(context).platformBrightness;
    final bool esModoOscuro =
        _tema == 'oscuro' || (_tema == 'auto' && brightness == Brightness.dark);

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
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  int tamanoTableroRows = _controller.difficulty.rows;
                  int tamanoTableroCols = _controller.difficulty.cols;
                  // Usamos cols para el ancho
                  int tamanoTablero = tamanoTableroCols;

                  // tamaño de casilla adaptativo
                  double maxAnchoTablero = screenSize.width * 0.85;
                  double maxAltoDisponible = screenSize.height * 0.6;
                  double casillaSize = (maxAnchoTablero / tamanoTablero).clamp(25, 55);

                  double altoTablero = casillaSize * tamanoTableroRows;
                  if (altoTablero > maxAltoDisponible) {
                    casillaSize = maxAltoDisponible / tamanoTableroRows;
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Panel de control
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFc957d2),
                            width: 1.8,
                          ),
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
                                Image.asset(
                                  'assets/imagenes/mina.png',
                                  width: 28,
                                  height: 28,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_controller.remainingMines}',
                                  style: GoogleFonts.pressStart2p(
                                    fontSize: 16,
                                    color: const Color(0xFFc957d2),
                                  ),
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

                            // Cronómetro visual (elapsedTime)
                            Text(
                              '${_controller.elapsedTime}',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 16,
                                color: const Color(0xFFc957d2),
                              ),
                            ),

                            // Separador
                            Container(
                              width: 1,
                              height: 28,
                              margin: const EdgeInsets.symmetric(horizontal: 18),
                              color: const Color(0xFFc957d2).withOpacity(0.4),
                            ),

                            // Botón reiniciar
                            _BotonReiniciar(onTap: _iniciarJuego),
                          ],
                        ),
                      ),

                      // Tablero borde neon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFFc957d2),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFc957d2).withOpacity(0.4),
                              blurRadius: 18,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Container(
                          width: casillaSize * tamanoTableroCols,
                          height: casillaSize * tamanoTableroRows,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: tamanoTableroCols,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: tamanoTableroRows * tamanoTableroCols,
                            itemBuilder: (context, index) {
                              int row = index ~/ tamanoTableroCols;
                              int col = index % tamanoTableroCols;
                              
                              // Check bounds just in case (flutter grid is flat)
                              if (row >= tamanoTableroRows || col >= tamanoTableroCols || _controller.board.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              final cell = _controller.board[row][col];
                              
                              return _Casilla(
                                casillaSize: casillaSize,
                                estiloNumeros: _estiloNumeros,
                                esModoOscuro: esModoOscuro,
                                revelada: cell.isRevealed,
                                tieneBandera: cell.isFlagged,
                                numero: cell.hasMine ? -1 : cell.adjacentMines,
                                onTap: () => _controller.tapCell(row, col),
                                onLongPress: () => _controller.flagCell(row, col),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
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
  final String estiloNumeros;
  final bool esModoOscuro;
  final bool revelada;
  final bool tieneBandera;
  final int numero;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _Casilla({
    required this.casillaSize,
    required this.estiloNumeros,
    required this.esModoOscuro,
    required this.revelada,
    required this.tieneBandera,
    required this.numero,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: casillaSize,
        height: casillaSize,
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: revelada
              ? (numero == -1
                    ? Colors.red[900]
                    : (esModoOscuro
                          ? Colors.grey[350]
                          : Colors.grey[200]))
              : (esModoOscuro ? Colors.grey[800] : Colors.grey[300]),
          border: Border.all(
            color: revelada
                ? Colors.white24
                : (esModoOscuro ? Colors.grey[600]! : Colors.grey[400]!),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: revelada
              ? _buildContenidoRevelado()
              : _buildContenidoTapado(),
        ),
      ),
    );
  }

  Widget _buildContenidoTapado() {
    if (tieneBandera) {
      return Image.asset(
        'assets/imagenes/bandera.png',
        width: casillaSize * 0.5,
        height: casillaSize * 0.5,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildContenidoRevelado() {
    if (numero == -1) {
      return Image.asset(
        'assets/imagenes/mina.png',
        width: casillaSize * 0.5,
        height: casillaSize * 0.5,
      );
    } else if (numero == 0) {
      return const SizedBox.shrink();
    } else {
      return Text(
        '$numero',
        style: GoogleFonts.pressStart2p(
          fontSize: casillaSize * 0.35,
          color: _obtenerColorNumero(numero),
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Color _obtenerColorNumero(int numeroLocal) {
    switch (estiloNumeros) {
      case 'colorido':
        switch (numeroLocal) {
          case 1:
            return const Color(0xFF00BFFF);
          case 2:
            return const Color(0xFF32CD32);
          case 3:
            return const Color(0xFFFF4500);
          case 4:
            return const Color(0xFF8A2BE2);
          case 5:
            return const Color(0xFFFF1493);
          case 6:
            return const Color(0xFF20B2AA);
          default:
            return Colors.white;
        }
      case 'retro':
        switch (numeroLocal) {
          case 1:
            return const Color(0xFF88A2C0);
          case 2:
            return const Color(0xFF8FBC8F);
          case 3:
            return const Color(0xFFCD5C5C);
          case 4:
            return const Color(0xFFB19CD9);
          case 5:
            return const Color(0xFFDDA0DD);
          case 6:
            return const Color(0xFF9ACD32);
          default:
            return Colors.white;
        }
      case 'minimalista':
        return esModoOscuro ? Colors.white : Colors.black;
      default:
        switch (numeroLocal) {
          case 1:
            return Colors.blue;
          case 2:
            return Colors.green;
          case 3:
            return Colors.red;
          case 4:
            return const Color(0xFF6ba8de);
          case 5:
            return const Color(0xFFc957d2);
          case 6:
            return const Color(0xFFfa798a);
          default:
            return Colors.white;
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
            border: Border.all(
              color: const Color(0xFFc957d2),
              width: _hover ? 3 : 2,
            ),
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
            border: Border.all(
              color: const Color(0xFFc957d2),
              width: _hover ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFc957d2).withOpacity(_hover ? 0.5 : 0.2),
                blurRadius: _hover ? 8 : 4,
              ),
            ],
          ),
          child: Text(
            '↻',
            style: GoogleFonts.pressStart2p(
              fontSize: 16,
              color: const Color(0xFFc957d2),
            ),
          ),
        ),
      ),
    );
  }
}
