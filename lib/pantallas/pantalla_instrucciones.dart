// Reglas del juego
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PantallaInstrucciones extends StatelessWidget {
  const PantallaInstrucciones({super.key});

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
            // Botón de volver 
            Positioned(
              top: 20,
              left: 20,
              child: _BotonVolver(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            
            // Cuadro 
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: screenSize.width * 0.8,
                  constraints: BoxConstraints(
                    maxWidth: 550,
                    minWidth: 300,
                    maxHeight: screenSize.height * 0.7,
                  ),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFf93cc7),  
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFf93cc7).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título  
                        Center(
                          child: Text(
                            'CÓMO JUGAR',
                            style: GoogleFonts.silkscreen(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFf93cc7),  
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        Center(
                          child: Text(
                            'MinePop',
                            style: GoogleFonts.silkscreen(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 25),
                        
                        // Objetivo 
                        Text(
                          '🎯 OBJETIVO',
                          style: GoogleFonts.silkscreen(
                            fontSize: 14,
                            color: const Color(0xFFf93cc7),  
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Despejar todo el tablero sin detonar ninguna bomba oculta.',
                          style: GoogleFonts.vt323(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // 1. Toca para revelar 
                        Text(
                          '1. TOCA PARA REVELAR',
                          style: GoogleFonts.silkscreen(
                            fontSize: 14,
                            color: const Color(0xFF6ba8de),  
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Haz clic izquierdo sobre cualquier casilla para ver qué hay debajo.\n'
                          '• Si sale un número, indica cuántas bombas hay en las casillas vecinas (arriba, abajo, lados y diagonal).\n'
                          '• Si la casilla está vacía, se abrirá automáticamente un área segura.',
                          style: GoogleFonts.vt323(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // 2. Usa la lógica 
                        Text(
                          '2. USA LA LÓGICA',
                          style: GoogleFonts.silkscreen(
                            fontSize: 14,
                            color: const Color(0xFFfa798a),  
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Si una casilla tiene un 1 y solo le queda una casilla vecina tapada, ¡ahí hay una bomba seguro!',
                          style: GoogleFonts.vt323(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // 3. Coloca la bandera 
                        Text(
                          '3. COLOCA LA BANDERA',
                          style: GoogleFonts.silkscreen(
                            fontSize: 14,
                            color: const Color(0xFFc957d2), 
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Haz clic derecho sobre una casilla si estás seguro de que hay una bomba.\n'
                          '• La bandera bloquea la casilla y evita que la pises por error.',
                          style: GoogleFonts.vt323(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // 4. Si explotas, pierdes 
                        Text(
                          '4. ¡SI EXPLOTAS, PIERDES!',
                          style: GoogleFonts.silkscreen(
                            fontSize: 14,
                            color: const Color(0xFFfdc445),  
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Si haces clic en una casilla donde hay una bomba, el juego termina inmediatamente.',
                          style: GoogleFonts.vt323(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                        
                        const SizedBox(height: 25),
                        
                        // Cómo ganar 
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFf93cc7).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFf93cc7).withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '🏆 CÓMO GANAR',
                                style: GoogleFonts.silkscreen(
                                  fontSize: 14,
                                  color: const Color(0xFFf93cc7),  
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ganas la partida cuando logras destapar todas las casillas seguras del tablero.\n\n'
                                'No hace falta poner banderas en todas las bombas para ganar, ¡lo importante es no explotar!',
                                style: GoogleFonts.vt323(
                                  fontSize: 14,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 10),
                      ],
                    ),
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

// Botón de volver 
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
              color: const Color(0xFFf93cc7),  
              width: _hover ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFf93cc7).withOpacity(_hover ? 0.7 : 0.3),
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