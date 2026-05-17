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
    
    _records = {
      'facil': [],
      'medio': [],
      'dificil': [],
    };
    setState(() {});
    
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
    final orientation = MediaQuery.of(context).orientation;
    final bool esMovil = screenSize.width < 600;
    final recordsActuales = _records[_dificultadSeleccionada] ?? [];
    
    // PC / Tablet 
    if (!esMovil) {
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
              Positioned(
                top: 20,
                left: 20,
                child: _BotonVolverPC(
                  onTap: () => Navigator.pop(context),
                ),
              ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildBotonDificultadPC('FÁCIL', 'facil', const Color(0xFF6ba8de)),
                            const SizedBox(width: 10),
                            _buildBotonDificultadPC('MEDIO', 'medio', const Color(0xFFfa798a)),
                            const SizedBox(width: 10),
                            _buildBotonDificultadPC('DIFÍCIL', 'dificil', const Color(0xFFc957d2)),
                          ],
                        ),
                        const SizedBox(height: 25),
                        recordsActuales.isEmpty
                            ? _buildMensajeVacioPC()
                            : _buildTablaRecordsPC(recordsActuales),
                        const SizedBox(height: 25),
                        if (recordsActuales.isNotEmpty)
                          _BotonBorrarPC(onTap: _borrarRecords),
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
    
    // Cell 
    double anchoCuadro;
    double paddingCuadro;
    double tituloSize;
    double botonDificultadSize;
    double fontSizeTabla;
    double volverSize;
    
    if (orientation == Orientation.landscape) {
      // Móvil horizontal
      anchoCuadro = screenSize.width * 0.7;
      paddingCuadro = 12;
      tituloSize = 14;
      botonDificultadSize = 9;
      fontSizeTabla = 10;
      volverSize = 40;
    } else {
      // Móvil vertical
      anchoCuadro = screenSize.width * 0.9;
      paddingCuadro = 20;
      tituloSize = 18;
      botonDificultadSize = 11;
      fontSizeTabla = 12;
      volverSize = 45;
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
            Positioned(
              top: 20,
              left: 20,
              child: _BotonVolverMovil(
                size: volverSize,
                onTap: () => Navigator.pop(context),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(orientation == Orientation.landscape ? 10 : 15),
                child: Container(
                  width: anchoCuadro,
                  constraints: const BoxConstraints(minWidth: 280),
                  padding: EdgeInsets.all(paddingCuadro),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF6ba8de),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6ba8de).withOpacity(0.4),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'MÁXIMAS\nPUNTUACIONES',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.silkscreen(
                          fontSize: tituloSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6ba8de),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildBotonDificultadMovil('FÁCIL', 'facil', const Color(0xFF6ba8de), botonDificultadSize),
                          _buildBotonDificultadMovil('MEDIO', 'medio', const Color(0xFFfa798a), botonDificultadSize),
                          _buildBotonDificultadMovil('DIFÍCIL', 'dificil', const Color(0xFFc957d2), botonDificultadSize),
                        ],
                      ),
                      const SizedBox(height: 15),
                      recordsActuales.isEmpty
                          ? _buildMensajeVacioMovil(fontSizeTabla)
                          : _buildTablaRecordsMovil(recordsActuales, fontSizeTabla),
                      const SizedBox(height: 15),
                      if (recordsActuales.isNotEmpty)
                        _BotonBorrarMovil(onTap: _borrarRecords, size: volverSize),
                      const SizedBox(height: 8),
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

  // PC 
  Widget _buildBotonDificultadPC(String texto, String dificultad, Color color) {
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

  Widget _buildTablaRecordsPC(List<Map<String, dynamic>> records) {
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF6ba8de).withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 50, child: Text('#', style: TextStyle(fontSize: 12))),
                const Expanded(child: Text('INTENTOS', style: TextStyle(fontSize: 12))),
                const Expanded(child: Text('FECHA', style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
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
                  Expanded(
                    child: Text(
                      '${record['intentos']}',
                      style: GoogleFonts.vt323(fontSize: 16, color: Colors.white),
                    ),
                  ),
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

  Widget _buildMensajeVacioPC() {
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

  // Cell 
  Widget _buildBotonDificultadMovil(String texto, String dificultad, Color color, double fontSize) {
    final seleccionado = _dificultadSeleccionada == dificultad;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _dificultadSeleccionada = dificultad),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: fontSize * 1.2, vertical: fontSize * 0.5),
          decoration: BoxDecoration(
            color: seleccionado ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color,
              width: seleccionado ? 0 : 1.5,
            ),
          ),
          child: Text(
            texto,
            style: GoogleFonts.silkscreen(
              fontSize: fontSize,
              color: seleccionado ? Colors.black : color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTablaRecordsMovil(List<Map<String, dynamic>> records, double fontSize) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF6ba8de).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF6ba8de).withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                SizedBox(width: 30, child: Text('#', style: TextStyle(fontSize: fontSize * 0.8))),
                Expanded(child: Text('INTENTOS', style: TextStyle(fontSize: fontSize * 0.8))),
                Expanded(child: Text('FECHA', style: TextStyle(fontSize: fontSize * 0.8))),
              ],
            ),
          ),
          ...List.generate(records.length, (index) {
            final record = records[index];
            final medalla = record['medalla'];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.white10 : Colors.transparent,
                border: index == records.length - 1
                    ? null
                    : const Border(bottom: BorderSide(color: Colors.white24)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: medalla == 'oro'
                        ? Icon(Icons.emoji_events, color: const Color(0xFFfdc445), size: fontSize + 2)
                        : medalla == 'plata'
                            ? Icon(Icons.emoji_events, color: const Color(0xFFc0c0c0), size: fontSize + 2)
                            : medalla == 'bronce'
                                ? Icon(Icons.emoji_events, color: const Color(0xFFcd7f32), size: fontSize + 2)
                                : Text('${index + 1}', style: GoogleFonts.vt323(fontSize: fontSize, color: Colors.white70)),
                  ),
                  Expanded(
                    child: Text(
                      '${record['intentos']}',
                      style: GoogleFonts.vt323(fontSize: fontSize, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      record['fecha'],
                      style: GoogleFonts.vt323(fontSize: fontSize * 0.85, color: Colors.white54),
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

  Widget _buildMensajeVacioMovil(double fontSize) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.emoji_events, color: Colors.white38, size: fontSize + 10),
          const SizedBox(height: 8),
          Text(
            'AÚN NO HAY RÉCORDS',
            style: GoogleFonts.silkscreen(fontSize: fontSize * 0.8, color: Colors.white38),
          ),
          const SizedBox(height: 4),
          Text(
            '¡Juega tu primera partida!',
            style: GoogleFonts.vt323(fontSize: fontSize, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}

// PC - Botón volver
class _BotonVolverPC extends StatefulWidget {
  final VoidCallback onTap;
  const _BotonVolverPC({required this.onTap});

  @override
  State<_BotonVolverPC> createState() => _BotonVolverPCState();
}

class _BotonVolverPCState extends State<_BotonVolverPC> {
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

// PC - Botón borrar
class _BotonBorrarPC extends StatefulWidget {
  final VoidCallback onTap;
  const _BotonBorrarPC({required this.onTap});

  @override
  State<_BotonBorrarPC> createState() => _BotonBorrarPCState();
}

class _BotonBorrarPCState extends State<_BotonBorrarPC> {
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

// Cell - Botón volver
class _BotonVolverMovil extends StatefulWidget {
  final VoidCallback onTap;
  final double size;
  const _BotonVolverMovil({required this.onTap, required this.size});

  @override
  State<_BotonVolverMovil> createState() => _BotonVolverMovilState();
}

class _BotonVolverMovilState extends State<_BotonVolverMovil> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    double iconSize = widget.size * 0.55;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.size,
          height: widget.size,
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
          child: Center(
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}

// Cell - Botón borrar
class _BotonBorrarMovil extends StatefulWidget {
  final VoidCallback onTap;
  final double size;
  const _BotonBorrarMovil({required this.onTap, required this.size});

  @override
  State<_BotonBorrarMovil> createState() => _BotonBorrarMovilState();
}

class _BotonBorrarMovilState extends State<_BotonBorrarMovil> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    double anchoBoton = widget.size * 3;
    double fontSize = widget.size * 0.25;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: anchoBoton.clamp(80, 150),
          height: widget.size * 0.7,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(15),
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
              'BORRAR',
              style: GoogleFonts.silkscreen(
                fontSize: fontSize.clamp(8, 10),
                color: const Color(0xFFfa798a),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Diálogo 
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
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
              fontSize: 9,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}