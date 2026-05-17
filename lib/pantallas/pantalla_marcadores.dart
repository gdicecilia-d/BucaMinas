// Tabla High Scores
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaMarcadores extends StatefulWidget {
  const PantallaMarcadores({super.key});

  @override
  State<PantallaMarcadores> createState() => _PantallaMarcadoresState();
}

class _PantallaMarcadoresState extends State<PantallaMarcadores> {
  String _dificultadSeleccionada = 'facil';
  Map<String, List<Map<String, dynamic>>> _records = {
    'facil': [],
    'medio': [],
    'dificil': [],
  };

  final Map<String, String> _dificultadNombre = {
    'facil': 'FÁCIL (6x6)',
    'medio': 'MEDIO (8x8)',
    'dificil': 'DIFÍCIL (10x10)',
  };

  final Map<String, Color> _dificultadColor = {
    'facil': const Color(0xFF6ba8de),
    'medio': const Color(0xFFfa798a),
    'dificil': const Color(0xFFc957d2),
  };

  @override
  void initState() {
    super.initState();
    _cargarRecords();
  }

  Future<void> _cargarRecords() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Cargar records de cada dificultad 
    for (var dificultad in ['facil', 'medio', 'dificil']) {
      final String? recordsJson = prefs.getString('records_$dificultad');
      if (recordsJson != null) {
        _records[dificultad] = [];
      } else {
        _records[dificultad] = [];
      }
    }
    setState(() {});
  }

  Future<void> _borrarRecords() async {
    _mostrarDialogoConfirmacion();
  }

  void _mostrarDialogoConfirmacion() {
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
              border: Border.all(
                color: const Color(0xFFfa798a),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFfa798a).withOpacity(0.5),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFfdc445),
                  size: 50,
                ),
                const SizedBox(height: 15),
                Text(
                  'BORRAR RÉCORDS',
                  style: GoogleFonts.silkscreen(
                    fontSize: 14,
                    color: const Color(0xFFfdc445),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '¿Estás seguro?\nEsta acción no se puede deshacer.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.vt323(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BotonDialogo(
                      texto: 'CANCELAR',
                      color: const Color(0xFF6ba8de),
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 15),
                    _BotonDialogo(
                      texto: 'BORRAR',
                      color: const Color(0xFFfa798a),
                      onTap: () {
                        Navigator.pop(context);
                        _confirmarBorrado();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmarBorrado() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('records_facil');
    await prefs.remove('records_medio');
    await prefs.remove('records_dificil');
    
    // Reiniciar con listas vacías
    _records = {
      'facil': [],
      'medio': [],
      'dificil': [],
    };
    setState(() {});
    
    // Mostrar mensaje de éxito
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Récords eliminados',
            style: GoogleFonts.vt323(fontSize: 14, color: Colors.white),
          ),
          backgroundColor: Colors.black.withOpacity(0.8),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final recordsActuales = _records[_dificultadSeleccionada] ?? [];
    
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
            // Botón de volver
            Positioned(
              top: 20,
              left: 20,
              child: _BotonVolver(
                onTap: () => Navigator.pop(context),
              ),
            ),
            
            // Cuadro centrado
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: screenSize.width * 0.9,
                  constraints: const BoxConstraints(maxWidth: 600, minWidth: 350),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF6ba8de),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6ba8de).withOpacity(0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título
                      Text(
                        'MÁXIMAS\nPUNTUACIONES',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.silkscreen(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6ba8de),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Selector de dificultad
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildBotonDificultad('FÁCIL', 'facil', const Color(0xFF6ba8de)),
                          const SizedBox(width: 10),
                          _buildBotonDificultad('MEDIO', 'medio', const Color(0xFFfa798a)),
                          const SizedBox(width: 10),
                          _buildBotonDificultad('DIFÍCIL', 'dificil', const Color(0xFFc957d2)),
                        ],
                      ),
                      
                      const SizedBox(height: 25),
                      
                      // Tabla de récords o mensaje vacío
                      recordsActuales.isEmpty
                          ? _buildMensajeVacio()
                          : _buildTablaRecords(recordsActuales),
                      
                      const SizedBox(height: 25),
                      
                      // Botón borrar récords (solo visible si hay récords)
                      if (recordsActuales.isNotEmpty)
                        _BotonBorrar(onTap: _borrarRecords),
                      
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonDificultad(String texto, String dificultad, Color color) {
    final seleccionado = _dificultadSeleccionada == dificultad;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _dificultadSeleccionada = dificultad),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: seleccionado ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color,
              width: seleccionado ? 0 : 2,
            ),
          ),
          child: Text(
            texto,
            style: GoogleFonts.silkscreen(
              fontSize: 12,
              color: seleccionado ? Colors.black : color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTablaRecords(List<Map<String, dynamic>> records) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF6ba8de).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Encabezados
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF6ba8de).withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 50, child: Text('#', style: TextStyle(fontSize: 12))),
                Expanded(child: Text('INTENTOS', style: TextStyle(fontSize: 12))),
                Expanded(child: Text('FECHA', style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
          
          // Filas de récords
          ...List.generate(records.length, (index) {
            final record = records[index];
            final medalla = record['medalla'];
            
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.white10 : Colors.transparent,
                border: index == records.length - 1
                    ? null
                    : const Border(bottom: BorderSide(color: Colors.white24)),
              ),
              child: Row(
                children: [
                  // Posición con medalla
                  SizedBox(
                    width: 50,
                    child: medalla == 'oro'
                        ? const Icon(Icons.emoji_events, color: Color(0xFFfdc445), size: 24)
                        : medalla == 'plata'
                            ? const Icon(Icons.emoji_events, color: Color(0xFFc0c0c0), size: 24)
                            : medalla == 'bronce'
                                ? const Icon(Icons.emoji_events, color: Color(0xFFcd7f32), size: 24)
                                : Text('${index + 1}', style: GoogleFonts.vt323(fontSize: 16, color: Colors.white70)),
                  ),
                  // Intentos
                  Expanded(
                    child: Text(
                      '${record['intentos']}',
                      style: GoogleFonts.vt323(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  // Fecha
                  Expanded(
                    child: Text(
                      record['fecha'],
                      style: GoogleFonts.vt323(fontSize: 14, color: Colors.white54),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMensajeVacio() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events, color: Colors.white38, size: 50),
          const SizedBox(height: 15),
          Text(
            'AÚN NO HAY RÉCORDS',
            style: GoogleFonts.silkscreen(fontSize: 12, color: Colors.white38),
          ),
          const SizedBox(height: 8),
          Text(
            '¡Juega tu primera partida!',
            style: GoogleFonts.vt323(fontSize: 14, color: Colors.white38),
          ),
        ],
      ),
    );
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
              color: const Color(0xFF6ba8de),
              width: _hover ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6ba8de).withOpacity(_hover ? 0.7 : 0.3),
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

// Botón borrar récords
class _BotonBorrar extends StatefulWidget {
  final VoidCallback onTap;
  const _BotonBorrar({required this.onTap});

  @override
  State<_BotonBorrar> createState() => _BotonBorrarState();
}

class _BotonBorrarState extends State<_BotonBorrar> {
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
          width: 180,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFfa798a),
              width: _hover ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFfa798a).withOpacity(_hover ? 0.5 : 0.2),
                blurRadius: _hover ? 12 : 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'BORRAR RÉCORDS',
              style: GoogleFonts.silkscreen(
                fontSize: 10,
                color: const Color(0xFFfa798a),
              ),
            ),
          ),
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
  const _BotonDialogo({
    required this.texto,
    required this.color,
    required this.onTap,
  });

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: widget.color,
              width: _hover ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_hover ? 0.5 : 0.2),
                blurRadius: _hover ? 12 : 5,
              ),
            ],
          ),
          child: Text(
            widget.texto,
            style: GoogleFonts.silkscreen(
              fontSize: 10,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}