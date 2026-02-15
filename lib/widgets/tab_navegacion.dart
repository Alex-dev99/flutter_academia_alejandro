import 'package:flutter/material.dart';

class TabNavegacion extends StatelessWidget {
  final IconData icono; 
  final String texto; 
  final bool estaSeleccionado;
  final VoidCallback onTap; 
  final Color? colorSeleccionado;
  
  const TabNavegacion({
    super.key,
    required this.icono,
    required this.texto,
    required this.estaSeleccionado,
    required this.onTap,
    this.colorSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    final Color colorActivo = colorSeleccionado ?? const Color(0xFF05A3C7);
    
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: estaSeleccionado ? colorActivo : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: estaSeleccionado
                ? [
                    BoxShadow(
                      color: colorActivo.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icono,
                size: 18,
                color: estaSeleccionado ? Colors.white : const Color(0xFF6B7280),
              ),
              const SizedBox(width: 6),
              Text(
                texto,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: estaSeleccionado ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
