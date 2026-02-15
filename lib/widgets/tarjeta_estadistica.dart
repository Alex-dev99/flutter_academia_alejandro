import 'package:flutter/material.dart';

class TarjetaEstadistica extends StatelessWidget {
  final IconData icono; 
  final Color colorIcono; 
  final Color colorFondoIcono;
  final String etiqueta;
  final String valor; 
  
  const TarjetaEstadistica({
    super.key,
    required this.icono,
    required this.colorIcono,
    required this.colorFondoIcono,
    required this.etiqueta,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorFondoIcono,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icono,
              color: colorIcono,
              size: 24,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            etiqueta,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            valor,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}
