import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../widgets/widgets.dart';

class DashboardAlumnoScreen extends StatefulWidget {
  const DashboardAlumnoScreen({super.key});

  @override
  State<DashboardAlumnoScreen> createState() => _DashboardAlumnoScreenState();
}

class _DashboardAlumnoScreenState extends State<DashboardAlumnoScreen> {
  int _tabSeleccionado = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFE),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(child: _buildHorario()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF05A3C7),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: const Icon(Icons.account_circle, color: Colors.white, size: 40),
              ),
              const SizedBox(width: 12),
              
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ana García', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('ID: 2024-001', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.logout, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text('Salir', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Transform.translate(
      offset: const Offset(0, 666),
      child: Row(
        children: [
          TabNavegacion(
            icono: Icons.calendar_month,
            texto: 'Horarios',
            estaSeleccionado: _tabSeleccionado == 0,
            onTap: () => setState(() => _tabSeleccionado = 0),
          ),
          const SizedBox(width: 8),
          TabNavegacion(
            icono: Icons.payments,
            texto: 'Pagos',
            estaSeleccionado: _tabSeleccionado == 1,
            onTap: () => setState(() => _tabSeleccionado = 1),
          ),
          const SizedBox(width: 8),
          TabNavegacion(
            icono: Icons.meeting_room,
            texto: 'Aulas',
            estaSeleccionado: _tabSeleccionado == 2,
            onTap: () => setState(() => _tabSeleccionado = 2),
          ),
        ],
      ),
    );
  }

  Widget _buildHorario() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Horario de Clases', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          const TarjetaClase(
            dia: 'Lunes',
            hora: '10:00 - 12:00',
            materia: 'HTML & CSS',
            aula: 'Aula 101',
            color: Color(0xFF05A3C7),
          ),
          const SizedBox(height: 12),
          
          const TarjetaClase(
            dia: 'Miércoles',
            hora: '14:00 - 16:00',
            materia: 'JavaScript',
            aula: 'Aula 102',
            color: Color(0xFF05A3C7),
          ),
          const SizedBox(height: 12),
          
          const TarjetaClase(
            dia: 'Viernes',
            hora: '10:00 - 12:00',
            materia: 'React',
            aula: 'Aula 101',
            color: Color(0xFF05A3C7),
          ),
        ],
      ),
    );
  }
}
