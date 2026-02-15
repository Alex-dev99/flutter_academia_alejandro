import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2FB0CC), 
      body: Stack(
        children: [
          NubeDecorativa(
            izquierda: -40,
            arriba: MediaQuery.of(context).size.height * 0.25,
            ancho: 192,
            opacidad: 0.5,
          ),
          NubeDecorativa(
            derecha: -50,
            arriba: MediaQuery.of(context).size.height * 0.33,
            ancho: 256,
            opacidad: 0.5,
          ),
          
          Column(
            children: [
              _buildHeader(),
              
              const Spacer(),
              
              _buildBotonesRol(context),
              
              const SizedBox(height: 32),
              
              _buildIlustracion(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 64, bottom: 16),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 96,
            height: 96,
          ),
          const SizedBox(height: 8),
          
          Stack(
            children: [
              Text(
                'ACADEMIA',
                style: TextStyle(
                  fontSize: 48,
                  letterSpacing: 4,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = Colors.white,
                ),
              ),
              const Text(
                'ACADEMIA',
                style: TextStyle(
                  fontSize: 48,
                  letterSpacing: 4,
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesRol(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          BotonRol(
            texto: 'SOY ALUMNO/A',
            onPress: () {
              Navigator.pushNamed(context, '/login-alumno_screen');
            },
          ),
          
          const SizedBox(height: 16),
          
          BotonRol(
            texto: 'SOY DOCENTE',
            onPress: () {
              Navigator.pushNamed(context, '/login-docente_screen');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIlustracion(BuildContext context) {
    return Image.asset(
      'assets/images/reading_illustration.png',
      width: MediaQuery.of(context).size.width * 0.9,
      fit: BoxFit.contain,
    );
  }
}
