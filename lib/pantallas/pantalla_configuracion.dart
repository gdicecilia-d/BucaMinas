// Opciones de dificultad, temas, sonido y animación  
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaConfiguracion extends StatefulWidget {
  const PantallaConfiguracion({super.key});

  @override
  State<PantallaConfiguracion> createState() => _PantallaConfiguracionState();
}

class _PantallaConfiguracionState extends State<PantallaConfiguracion> {
  String _dificultad = 'facil';
  String _tema = 'auto';
  String _estiloNumeros = 'clasico';
  bool _sonidoActivado = true;
  bool _animacionesActivadas = true;

  @override
  void initState() {
    super.initState();
    _cargarConfiguracion();
  }

  Future<void> _cargarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dificultad = prefs.getString('dificultad') ?? 'facil';
      _tema = prefs.getString('tema') ?? 'auto';
      _estiloNumeros = prefs.getString('estiloNumeros') ?? 'clasico';
      _sonidoActivado = prefs.getBool('sonido') ?? true;
      _animacionesActivadas = prefs.getBool('animaciones') ?? true;
    });
  }

  Future<void> _guardarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dificultad', _dificultad);
    await prefs.setString('tema', _tema);
    await prefs.setString('estiloNumeros', _estiloNumeros);
    await prefs.setBool('sonido', _sonidoActivado);
    await prefs.setBool('animaciones', _animacionesActivadas);
    
    if (mounted) {
      _mostrarDialogoGuardado();
    }
  }

  void _mostrarDialogoGuardado() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
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
                  Icons.check_circle,
                  color: Color(0xFFfa798a),
                  size: 50,
                ),
                const SizedBox(height: 15),
                Text(
                  'CONFIGURACIÓN',
                  style: GoogleFonts.silkscreen(
                    fontSize: 16,
                    color: const Color(0xFFfa798a),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Guardada con éxito',
                  style: GoogleFonts.vt323(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFfa798a).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFfa798a),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'ACEPTAR',
                        style: GoogleFonts.silkscreen(
                          fontSize: 12,
                          color: const Color(0xFFfa798a),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final bool esHorizontal = orientation == Orientation.landscape;
    final bool esMovil = screenSize.width < 600;
    
    // Ajustes según orientación y tamaño
    double anchoCuadro;
    double paddingCuadro;
    double tituloSize;
    double fontSizeSeccion;
    double fontSizeOpcion;
    double fontSizeSwitch;
    double volverSize;
    
    if (esHorizontal && esMovil) {
      // Horizontal en cell
      anchoCuadro = screenSize.width * 0.9;
      paddingCuadro = 15;
      tituloSize = 18;
      fontSizeSeccion = 10;
      fontSizeOpcion = 11;
      fontSizeSwitch = 12;
      volverSize = 40;
    } else if (esMovil) {
      // Vertical en cell
      anchoCuadro = screenSize.width * 0.9;
      paddingCuadro = 20;
      tituloSize = 20;
      fontSizeSeccion = 12;
      fontSizeOpcion = 13;
      fontSizeSwitch = 14;
      volverSize = 45;
    } else {
      // PC / Tablet
      anchoCuadro = screenSize.width * 0.85;
      paddingCuadro = 25;
      tituloSize = 24;
      fontSizeSeccion = 14;
      fontSizeOpcion = 15;
      fontSizeSwitch = 15;
      volverSize = 50;
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
              child: _BotonVolver(
                size: volverSize,
                onTap: () => Navigator.pop(context),
              ),
            ),
            
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Container(
                  width: anchoCuadro,
                  constraints: const BoxConstraints(maxWidth: 500, minWidth: 280),
                  padding: EdgeInsets.all(paddingCuadro),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFfa798a),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFfa798a).withOpacity(0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CONFIGURACIÓN',
                        style: GoogleFonts.silkscreen(
                          fontSize: tituloSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFfa798a),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Dificultad 
                      _buildSeccion(
                        titulo: 'DIFICULTAD',
                        colorTitulo: const Color(0xFF6ba8de),
                        fontSize: fontSizeSeccion,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildOpcion('FÁCIL', _dificultad == 'facil', const Color(0xFF6ba8de), fontSizeOpcion, () => setState(() => _dificultad = 'facil')),
                            _buildOpcion('MEDIO', _dificultad == 'medio', const Color(0xFFfa798a), fontSizeOpcion, () => setState(() => _dificultad = 'medio')),
                            _buildOpcion('DIFÍCIL', _dificultad == 'dificil', const Color(0xFFc957d2), fontSizeOpcion, () => setState(() => _dificultad = 'dificil')),
                          ],
                        ),
                      ),
                      
                      // Tema
                      _buildSeccion(
                        titulo: 'TEMA',
                        colorTitulo: const Color(0xFFfdc445),
                        fontSize: fontSizeSeccion,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildOpcion('CLARO', _tema == 'claro', const Color(0xFFfdc445), fontSizeOpcion, () => setState(() => _tema = 'claro')),
                            _buildOpcion('OSCURO', _tema == 'oscuro', const Color(0xFFc957d2), fontSizeOpcion, () => setState(() => _tema = 'oscuro')),
                            _buildOpcion('AUTO', _tema == 'auto', const Color(0xFF6ba8de), fontSizeOpcion, () => setState(() => _tema = 'auto')),
                          ],
                        ),
                      ),
                      
                      // Estilo de numeros
                      _buildSeccion(
                        titulo: 'ESTILO DE NÚMEROS',
                        colorTitulo: const Color(0xFFc957d2),
                        fontSize: fontSizeSeccion,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildOpcion('CLÁSICO', _estiloNumeros == 'clasico', const Color(0xFF6ba8de), fontSizeOpcion, () => setState(() => _estiloNumeros = 'clasico')),
                            _buildOpcion('COLORIDO', _estiloNumeros == 'colorido', const Color(0xFFfa798a), fontSizeOpcion, () => setState(() => _estiloNumeros = 'colorido')),
                            _buildOpcion('RETRO', _estiloNumeros == 'retro', const Color(0xFFfdc445), fontSizeOpcion, () => setState(() => _estiloNumeros = 'retro')),
                            _buildOpcion('MINIMALISTA', _estiloNumeros == 'minimalista', const Color(0xFFc957d2), fontSizeOpcion, () => setState(() => _estiloNumeros = 'minimalista')),
                          ],
                        ),
                      ),
                      
                      // Efectos
                      _buildSeccion(
                        titulo: 'EFECTOS',
                        colorTitulo: const Color(0xFFfa798a),
                        fontSize: fontSizeSeccion,
                        child: Column(
                          children: [
                            _buildSwitch(
                              label: 'Efectos de sonido',
                              value: _sonidoActivado,
                              color: const Color(0xFFfdc445),
                              fontSize: fontSizeSwitch,
                              onChanged: (val) {
                                setState(() {
                                  _sonidoActivado = val;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            _buildSwitch(
                              label: 'Animaciones',
                              value: _animacionesActivadas,
                              color: const Color(0xFFc957d2),
                              fontSize: fontSizeSwitch,
                              onChanged: (val) {
                                setState(() {
                                  _animacionesActivadas = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      _BotonGuardar(onTap: _guardarConfiguracion, size: volverSize),
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

  Widget _buildSeccion({required String titulo, required Color colorTitulo, required double fontSize, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: GoogleFonts.silkscreen(fontSize: fontSize, color: colorTitulo),
        ),
        const SizedBox(height: 8),
        child,
        const Divider(color: Colors.white24, height: 20),
      ],
    );
  }

  Widget _buildOpcion(String texto, bool seleccionado, Color color, double fontSize, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: seleccionado ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color,
              width: seleccionado ? 0 : 1.5,
            ),
          ),
          child: Text(
            texto,
            style: GoogleFonts.vt323(
              fontSize: fontSize,
              color: seleccionado ? Colors.black : color,
              fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required String label,
    required bool value,
    required Color color,
    required double fontSize,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.vt323(fontSize: fontSize, color: Colors.white70),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: color,
          activeTrackColor: color.withOpacity(0.5),
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.withOpacity(0.3),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}

// Botón Guardar 
class _BotonGuardar extends StatefulWidget {
  final VoidCallback onTap;
  final double size;
  const _BotonGuardar({required this.onTap, required this.size});

  @override
  State<_BotonGuardar> createState() => _BotonGuardarState();
}

class _BotonGuardarState extends State<_BotonGuardar> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    double anchoBoton = widget.size * 4;
    double altoBoton = widget.size * 1;
    double fontSize = widget.size * 0.32;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: anchoBoton.clamp(120, 200),
          height: altoBoton.clamp(35, 50),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFfa798a),
              width: _hover ? 2.5 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFfa798a).withOpacity(_hover ? 0.6 : 0.3),
                blurRadius: _hover ? 15 : 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'GUARDAR',
              style: GoogleFonts.silkscreen(
                fontSize: fontSize.clamp(10, 16),
                color: const Color(0xFFfa798a),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Botón volver 
class _BotonVolver extends StatefulWidget {
  final VoidCallback onTap;
  final double size;
  const _BotonVolver({required this.onTap, required this.size});

  @override
  State<_BotonVolver> createState() => _BotonVolverState();
}

class _BotonVolverState extends State<_BotonVolver> {
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
              color: const Color(0xFFfa798a),
              width: _hover ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFfa798a).withOpacity(_hover ? 0.7 : 0.3),
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