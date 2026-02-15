import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/widgets.dart';

class LoginAlumnoScreen extends StatefulWidget {
  const LoginAlumnoScreen({super.key});

  @override
  State<LoginAlumnoScreen> createState() => _LoginAlumnoScreenState();
}

class _LoginAlumnoScreenState extends State<LoginAlumnoScreen> {
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
        if (state is AuthAuthenticated && !state.isTeacher) {
          Navigator.pushReplacementNamed(context, '/dashboard-alumno');
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
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'assets/images/student_illustration.png',
                width: 192,
              ),
            ),
            
            const NubeDecorativa(
              abajo: -40,
              derecha: -40,
              ancho: 256,
              opacidad: 0.4,
            ),
            
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    _buildTitulo(),
                    const SizedBox(height: 40),
                    _buildFormulario(),
                    const SizedBox(height: 32),
                    _buildBotonLogin(),
                    const SizedBox(height: 16),
                    _buildLinkRegistro(),
                    const SizedBox(height: 200),
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
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        
        const SizedBox(width: 32), 
      ],
    );
  }

  Widget _buildTitulo() {
    return Column(
      children: [
        const Text(
          'Log in Alumno/a',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '¡Bienvenido de nuevo a tu clase!',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildFormulario() {
    return Column(
      children: [
        CampoTexto(
          etiqueta: 'Username or Email',
          controlador: _usuarioController,
        ),
        
        const SizedBox(height: 20),
        
        CampoTexto(
          etiqueta: 'Password',
          controlador: _passwordController,
          esPassword: true, 
          widgetExtra: GestureDetector(
            onTap: () {
            },
            child: Text(
              'Forgot?',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotonLogin() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final estaCargando = state is AuthLoading;
        
        return BotonLogin(
          estaCargando: estaCargando,
          onPress: () {
            context.read<AuthBloc>().add(
                  LoginEvent(
                    username: _usuarioController.text,
                    password: _passwordController.text,
                    isTeacher: false,
                  ),
                );
          },
        );
      },
    );
  }

  Widget _buildLinkRegistro() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Aún no tienes cuenta?',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () {
          },
          child: const Text(
            'Regístrate',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
