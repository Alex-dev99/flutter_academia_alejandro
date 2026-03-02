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
          Expanded(
            child: _buildContenidoSegunTab(), 
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(), 
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40), 
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), 
      child: Row(
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
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _tabSeleccionado,
      onTap: (index) {
        setState(() {
          _tabSeleccionado = index;
        });
      },
      type: BottomNavigationBarType.fixed, 
      selectedItemColor: const Color(0xFF9333EA),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Horario',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Alumnos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.domain),
          label: 'Aulas',
        ),
      ],
    );
  }

  Widget _buildContenidoSegunTab() {
    switch (_tabSeleccionado) {
      case 0:
        return _buildHorarioProfesor();
      case 1:
        return _buildListaAlumnos();
      case 2:
        return _buildAulasProfesor();
      default:
        return _buildListaAlumnos();
    }
  }

  Widget _buildHorarioProfesor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Mi Horario', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          TarjetaClaseProfesor(
            dia: 'Lunes',
            hora: '10:00 - 12:00',
            materia: 'Programación Web',
            aula: 'Aula 101',
            grupo: 'Grupo A',
          ),
          SizedBox(height: 16),
          TarjetaClaseProfesor(
            dia: 'Miércoles',
            hora: '14:00 - 16:00',
            materia: 'JavaScript Avanzado',
            aula: 'Lab. Cómputo',
            grupo: 'Grupo B',
          ),
          SizedBox(height: 16),
          TarjetaClaseProfesor(
            dia: 'Viernes',
            hora: '08:00 - 10:00',
            materia: 'React',
            aula: 'Aula 102',
            grupo: 'Grupo A',
          ),
        ],
      ),
    );
  }

  Widget _buildListaAlumnos() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Lista de Alumnos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          TarjetaAlumno(
            nombre: 'Ana García',
            id: '2024-001',
            curso: 'Programación Web',
          ),
          SizedBox(height: 16),
          TarjetaAlumno(
            nombre: 'Luis Pérez',
            id: '2024-002',
            curso: 'Programación Web',
          ),
          SizedBox(height: 16),
          TarjetaAlumno(
            nombre: 'María Sánchez',
            id: '2024-003',
            curso: 'Diseño Web',
          ),
        ],
      ),
    );
  }

  Widget _buildAulasProfesor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Aulas Disponibles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          TarjetaAulaProfesor(
            nombre: 'Aula 101',
            capacidad: '30',
            equipamiento: 'Proyector, Pizarra',
            horario: 'Libre: 12:00 - 14:00',
          ),
          SizedBox(height: 16),
          TarjetaAulaProfesor(
            nombre: 'Aula 102',
            capacidad: '25',
            equipamiento: 'Computadoras',
            horario: 'Ocupado hasta 15:00',
          ),
          SizedBox(height: 16),
          TarjetaAulaProfesor(
            nombre: 'Lab. Cómputo',
            capacidad: '20',
            equipamiento: 'PCs, Software',
            horario: 'Disponible todo el día',
          ),
        ],
      ),
    );
  }
}


class TarjetaClaseProfesor extends StatelessWidget {
  final String dia, hora, materia, aula, grupo;
  const TarjetaClaseProfesor({
    super.key,
    required this.dia,
    required this.hora,
    required this.materia,
    required this.aula,
    required this.grupo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$dia • $hora',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9333EA))),
          const SizedBox(height: 8),
          Text(materia, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text('Aula: $aula • $grupo', style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class TarjetaAulaProfesor extends StatelessWidget {
  final String nombre, capacidad, equipamiento, horario;
  const TarjetaAulaProfesor({
    super.key,
    required this.nombre,
    required this.capacidad,
    required this.equipamiento,
    required this.horario,
  });

  @override
  Widget build(BuildContext context) {
    final bool disponible = horario.contains('Disponible') || horario.contains('Libre');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text('Capacidad: $capacidad estudiantes'),
          Text('Equipamiento: $equipamiento'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: disponible ? Colors.green.shade100 : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              horario,
              style: TextStyle(
                fontSize: 12,
                color: disponible ? Colors.green.shade900 : Colors.orange.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}