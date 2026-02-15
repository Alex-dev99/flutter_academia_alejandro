import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../widgets/widgets.dart';

class DashboardProfesorScreen extends StatefulWidget {
  const DashboardProfesorScreen({super.key});

  @override
  State<DashboardProfesorScreen> createState() => _DashboardProfesorScreenState();
}

class _DashboardProfesorScreenState extends State<DashboardProfesorScreen> {
  int _tabSeleccionado = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          _buildEstadisticas(),
          _buildTabs(),
          Expanded(child: _buildListaAlumnos()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8B22E2), Color(0xFF6D28D9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 80),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prof. Carlos Ruiz', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Departamento de Tecnología', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA855F7).withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.logout, size: 18, color: Colors.white),
                    SizedBox(width: 4),
                    Text('Salir', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadisticas() {
    return Transform.translate(
      offset: const Offset(0, -64),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: TarjetaEstadistica(
                    icono: Icons.calendar_today,
                    colorIcono: Color(0xFF9333EA),
                    colorFondoIcono: Color(0xFFF5EEFF),
                    etiqueta: 'Clases esta semana',
                    valor: '4',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TarjetaEstadistica(
                    icono: Icons.group,
                    colorIcono: Color(0xFF3B82F6),
                    colorFondoIcono: Color(0xFFEFF6FF),
                    etiqueta: 'Total de Alumnos',
                    valor: '5',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TarjetaEstadistica(
                    icono: Icons.domain,
                    colorIcono: Color(0xFF10B981),
                    colorFondoIcono: Color(0xFFECFDF5),
                    etiqueta: 'Aulas Disponibles',
                    valor: '3',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Transform.translate(
      offset: const Offset(0, -48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            TabNavegacion(
              icono: Icons.calendar_month,
              texto: 'Horario',
              estaSeleccionado: _tabSeleccionado == 0,
              colorSeleccionado: const Color(0xFF9333EA),
              onTap: () => setState(() => _tabSeleccionado = 0),
            ),
            const SizedBox(width: 12),
            TabNavegacion(
              icono: Icons.group,
              texto: 'Alumnos',
              estaSeleccionado: _tabSeleccionado == 1,
              colorSeleccionado: const Color(0xFF9333EA),
              onTap: () => setState(() => _tabSeleccionado = 1),
            ),
            const SizedBox(width: 12),
            TabNavegacion(
              icono: Icons.domain,
              texto: 'Aulas',
              estaSeleccionado: _tabSeleccionado == 2,
              colorSeleccionado: const Color(0xFF9333EA),
              onTap: () => setState(() => _tabSeleccionado = 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaAlumnos() {
    return Transform.translate(
      offset: const Offset(0, -48),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Lista de Alumnos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
              
              TarjetaAlumno(
                nombre: 'Ana García',
                id: '2024-001',
                curso: 'Programación Web',
                asistencia: 95,
                colorAsistencia: Color(0xFFECFDF5),
                colorTextoAsistencia: Color(0xFF059669),
                nota: 8.5,
              ),
              SizedBox(height: 16),
              
              TarjetaAlumno(
                nombre: 'Luis Pérez',
                id: '2024-002',
                curso: 'Programación Web',
                asistencia: 88,
                colorAsistencia: Color(0xFFFFF7ED),
                colorTextoAsistencia: Color(0xFFD97706),
                nota: 7.8,
              ),
              SizedBox(height: 16),
              
              TarjetaAlumno(
                nombre: 'María Sánchez',
                id: '2024-003',
                curso: 'Diseño Web',
                asistencia: 92,
                colorAsistencia: Color(0xFFECFDF5),
                colorTextoAsistencia: Color(0xFF059669),
                nota: 9.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
