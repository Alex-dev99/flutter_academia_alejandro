import 'package:flutter/material.dart';

class NubeDecorativa extends StatelessWidget {
  final double? izquierda;  
  final double? derecha;    
  final double? arriba; 
  final double? abajo; 
  final double ancho; 
  final double opacidad; 
  
  const NubeDecorativa({
    super.key,
    this.izquierda,
    this.derecha,
    this.arriba,
    this.abajo,
    this.ancho = 192,
    this.opacidad = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: izquierda,
      right: derecha,
      top: arriba,
      bottom: abajo,
      child: Opacity(
        opacity: opacidad,
        child: Image.asset(
          'assets/images/cloud.png',
          width: ancho,
        ),
      ),
    );
  }
}
