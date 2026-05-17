// Pantalla de Créditos
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PantallaCreditos extends StatelessWidget {
  const PantallaCreditos({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
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
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            
            // Cuadro neon 
            Center(
              child: Container(
                width: screenSize.width * 0.7,
                constraints: BoxConstraints(
                  maxWidth: 500,
                  minWidth: 300,
                ),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
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
                        fontSize: 28,
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
                        fontSize: 18,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                    
                    const Divider(
                      color: Colors.white30,
                      height: 1,
                    ),
                    const SizedBox(height: 20),  // CORREGIDO: Separado el const
                    
                    // Desarrollado por
                    Text(
                      'Desarrollado por:',
                      style: GoogleFonts.vt323(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Nombres
                    Text(
                      'Grazia Di Cecilia',
                      style: GoogleFonts.silkscreen(
                        fontSize: 14,
                        color: const Color(0xFFc957d2),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    Text(
                      'Juan Coll',
                      style: GoogleFonts.silkscreen(
                        fontSize: 14,
                        color: const Color(0xFF6ba8de),
                      ),
                    ),
                    
                    const SizedBox(height: 25),
                    
                    // Universidad
                    Text(
                      'Universidad Metropolitana',
                      style: GoogleFonts.vt323(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      'Caracas, Venezuela',
                      style: GoogleFonts.vt323(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    
                    const SizedBox(height: 25),
                    
                    // Copyright
                    Text(
                      '© 2026',
                      style: GoogleFonts.silkscreen(
                        fontSize: 12,
                        color: const Color(0xFFfdc445),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BOTÓN DE VOLVER (flecha neon)
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
          duration: const Duration(milliseconds: 200),
          width: 50,
          height: 50,
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
          child: const Center(
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}