import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/widgets.dart';

class LoginDocenteScreen extends StatefulWidget {
  const LoginDocenteScreen({super.key});

  @override
  State<LoginDocenteScreen> createState() => _LoginDocenteScreenState();
}

class _LoginDocenteScreenState extends State<LoginDocenteScreen> {
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated && state.isTeacher) {
          Navigator.pushReplacementNamed(context, '/dashboard-profesor');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      
      child: Scaffold(
        backgroundColor: const Color(0xFF05A3C7),
        body: Stack(
          children: [
            const NubeDecorativa(
              abajo: 150,
              izquierda: -10,
              ancho: 192,
              opacidad: 0.4,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/images/teacher_illustration.png',
                width: 250,
              ),
              
            ),


            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 50),
                    const Text(
                      'Log in docente',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¡Bienvenido de nuevo!',
                      // ignore: deprecated_member_use
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    CampoTexto(etiqueta: 'Username or Email', controlador: _usuarioController),
                    const SizedBox(height: 20),
                    CampoTexto(etiqueta: 'Password', controlador: _passwordController, esPassword: true),
                    const SizedBox(height: 32),
                    _buildBotonLogin(),
                    const SizedBox(height: 280),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28)),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
          ),
          child: ClipRRect(borderRadius: BorderRadius.circular(32), child: Image.asset('assets/images/logo.png')),
        ),
        const SizedBox(width: 32),
      ],
    );
  }

  Widget _buildBotonLogin() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return BotonLogin(
          estaCargando: state is AuthLoading,
          onPress: () {
            context.read<AuthBloc>().add(
                  LoginEvent(
                    username: _usuarioController.text,
                    password: _passwordController.text,
                    isTeacher: true, 
                  ),
                );
          },
        );
      },
    );
  }
}
