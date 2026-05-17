// Pantalla de Créditos 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PantallaCreditos extends StatelessWidget {
  const PantallaCreditos({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final bool esHorizontal = orientation == Orientation.landscape;
    final bool esMovil = screenSize.width < 600;
    
    // según orientación y tamaño
    double anchoCuadro;
    double paddingCuadro;
    double tituloSize;
    double subtituloSize;
    double textoSize;
    double nombreSize;
    double volverSize;
    
    if (esHorizontal && esMovil) {
      // Horizontal en móvil
      anchoCuadro = screenSize.width * 0.85;
      paddingCuadro = 20;
      tituloSize = 22;
      subtituloSize = 14;
      textoSize = 12;
      nombreSize = 11;
      volverSize = 40;
    } else if (esMovil) {
      // Vertical en móvil
      anchoCuadro = screenSize.width * 0.85;
      paddingCuadro = 25;
      tituloSize = 24;
      subtituloSize = 16;
      textoSize = 14;
      nombreSize = 12;
      volverSize = 45;
    } else {
      // PC / Tablet
      anchoCuadro = screenSize.width * 0.7;
      paddingCuadro = 30;
      tituloSize = 28;
      subtituloSize = 18;
      textoSize = 16;
      nombreSize = 14;
      volverSize = 50;
    }
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        // Fondo 
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagenes/fondo_principal.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Boton volver
            Positioned(
              top: 20,
              left: 20,
              child: _BotonVolver(
                size: volverSize,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            
            // Cuadro neon 
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: anchoCuadro,
                  constraints: BoxConstraints(
                    maxWidth: 500,
                    minWidth: 280,
                  ),
                  padding: EdgeInsets.all(paddingCuadro),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFfdc445),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFfdc445).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título 
                      Text(
                        'MINEPOP',
                        style: GoogleFonts.silkscreen(
                          fontSize: tituloSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFfdc445),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Subtítulo
                      Text(
                        'Busca. Piensa. ¡Explota!',
                        style: GoogleFonts.vt323(
                          fontSize: subtituloSize,
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                      ),
                      
                      const Divider(
                        color: Colors.white30,
                        height: 1,
                      ),
                      const SizedBox(height: 20),
                      
                      // Desarrollado por
                      Text(
                        'Desarrollado por:',
                        style: GoogleFonts.vt323(
                          fontSize: textoSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      // Nombres
                      Text(
                        'Grazia Di Cecilia',
                        style: GoogleFonts.silkscreen(
                          fontSize: nombreSize,
                          color: const Color(0xFFc957d2),
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      Text(
                        'Juan Coll',
                        style: GoogleFonts.silkscreen(
                          fontSize: nombreSize,
                          color: const Color(0xFF6ba8de),
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      
                      // Universidad
                      Text(
                        'Universidad Metropolitana',
                        style: GoogleFonts.vt323(
                          fontSize: textoSize - 2,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        'Caracas, Venezuela',
                        style: GoogleFonts.vt323(
                          fontSize: textoSize - 2,
                          color: Colors.white70,
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      
                      // Copyright
                      Text(
                        '© 2026',
                        style: GoogleFonts.silkscreen(
                          fontSize: tituloSize * 0.4,
                          color: const Color(0xFFfdc445),
                        ),
                      ),
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
}

// Boton volver
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
          duration: const Duration(milliseconds: 200),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
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