// Opciones de dificultad y temas
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
                onTap: () => Navigator.pop(context),
              ),
            ),
            
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: screenSize.width * 0.85,
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(25),
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFfa798a),
                        ),
                      ),
                      const SizedBox(height: 25),
                      
                      // Dificultad 
                      _buildSeccion(
                        titulo: 'DIFICULTAD',
                        colorTitulo: const Color(0xFF6ba8de),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildOpcion('FÁCIL', _dificultad == 'facil', const Color(0xFF6ba8de), () => setState(() => _dificultad = 'facil')),
                            _buildOpcion('MEDIO', _dificultad == 'medio', const Color(0xFFfa798a), () => setState(() => _dificultad = 'medio')),
                            _buildOpcion('DIFÍCIL', _dificultad == 'dificil', const Color(0xFFc957d2), () => setState(() => _dificultad = 'dificil')),
                          ],
                        ),
                      ),
                      
                      // Tema
                      _buildSeccion(
                        titulo: 'TEMA',
                        colorTitulo: const Color(0xFFfdc445),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildOpcion('CLARO', _tema == 'claro', const Color(0xFFfdc445), () => setState(() => _tema = 'claro')),
                            _buildOpcion('OSCURO', _tema == 'oscuro', const Color(0xFFc957d2), () => setState(() => _tema = 'oscuro')),
                            _buildOpcion('AUTO', _tema == 'auto', const Color(0xFF6ba8de), () => setState(() => _tema = 'auto')),
                          ],
                        ),
                      ),
                      
                      // Estilo de numeros
                      _buildSeccion(
                        titulo: 'ESTILO DE NÚMEROS',
                        colorTitulo: const Color(0xFFc957d2),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildOpcion('CLÁSICO', _estiloNumeros == 'clasico', const Color(0xFF6ba8de), () => setState(() => _estiloNumeros = 'clasico')),
                            _buildOpcion('COLORIDO', _estiloNumeros == 'colorido', const Color(0xFFfa798a), () => setState(() => _estiloNumeros = 'colorido')),
                            _buildOpcion('RETRO', _estiloNumeros == 'retro', const Color(0xFFfdc445), () => setState(() => _estiloNumeros = 'retro')),
                            _buildOpcion('MINIMALISTA', _estiloNumeros == 'minimalista', const Color(0xFFc957d2), () => setState(() => _estiloNumeros = 'minimalista')),
                          ],
                        ),
                      ),
                      
                      // Efectos
                      _buildSeccion(
                        titulo: 'EFECTOS',
                        colorTitulo: const Color(0xFFfa798a),
                        child: Column(
                          children: [
                            _buildSwitch(
                              label: 'Efectos de sonido',
                              value: _sonidoActivado,
                              color: const Color(0xFFfdc445),
                              onChanged: (val) {
                                setState(() {
                                  _sonidoActivado = val;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildSwitch(
                              label: 'Animaciones',
                              value: _animacionesActivadas,
                              color: const Color(0xFFc957d2),
                              onChanged: (val) {
                                setState(() {
                                  _animacionesActivadas = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      
                      _BotonGuardar(onTap: _guardarConfiguracion),
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

  Widget _buildSeccion({required String titulo, required Color colorTitulo, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: GoogleFonts.silkscreen(fontSize: 14, color: colorTitulo),
        ),
        const SizedBox(height: 10),
        child,
        const Divider(color: Colors.white24, height: 25),
      ],
    );
  }

  Widget _buildOpcion(String texto, bool seleccionado, Color color, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
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
            style: GoogleFonts.vt323(
              fontSize: 15,
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
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.vt323(fontSize: 15, color: Colors.white70),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: color,
          activeTrackColor: color.withOpacity(0.5),
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.withOpacity(0.3),
        ),
      ],
    );
  }
}

// Botón Guardar 
class _BotonGuardar extends StatefulWidget {
  final VoidCallback onTap;
  const _BotonGuardar({required this.onTap});

  @override
  State<_BotonGuardar> createState() => _BotonGuardarState();
}

class _BotonGuardarState extends State<_BotonGuardar> {
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
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(25),
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
                fontSize: 16,
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
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}