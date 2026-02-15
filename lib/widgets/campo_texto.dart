import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final String etiqueta;                    
  final TextEditingController controlador;  
  final bool esPassword;                    
  final Widget? widgetExtra;                
  
  const CampoTexto({
    super.key,
    required this.etiqueta,
    required this.controlador,
    this.esPassword = false,
    this.widgetExtra,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                etiqueta,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widgetExtra != null) widgetExtra!,
            ],
          ),
        ),
        
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controlador,
            obscureText: esPassword, 
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF334155),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
