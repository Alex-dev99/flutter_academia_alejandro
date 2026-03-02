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
                    Text('Ana García',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _tabSeleccionado,
      onTap: (index) {
        setState(() {
          _tabSeleccionado = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF05A3C7),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Horarios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payments),
          label: 'Pagos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.meeting_room),
          label: 'Aulas',
        ),
      ],
    );
  }

  Widget _buildContenidoSegunTab() {
    switch (_tabSeleccionado) {
      case 0:
        return _buildHorario();
      case 1:
        return _buildPagos();
      case 2:
        return _buildAulas();
      default:
        return _buildHorario();
    }
  }

  Widget _buildHorario() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Horario de Clases', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TarjetaClase(
            dia: 'Lunes',
            hora: '10:00 - 12:00',
            materia: 'HTML & CSS',
            aula: 'Aula 101',
            color: Color(0xFF05A3C7),
          ),
          SizedBox(height: 12),
          TarjetaClase(
            dia: 'Miércoles',
            hora: '14:00 - 16:00',
            materia: 'JavaScript',
            aula: 'Aula 102',
            color: Color(0xFF05A3C7),
          ),
          SizedBox(height: 12),
          TarjetaClase(
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

  Widget _buildPagos() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Estado de Pagos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TarjetaPago(
            concepto: 'Mensualidad Marzo',
            monto: '\$150',
            fecha: '15/03/2025',
            estado: 'Pagado',
          ),
          SizedBox(height: 12),
          TarjetaPago(
            concepto: 'Mensualidad Abril',
            monto: '\$150',
            fecha: '15/04/2025',
            estado: 'Pendiente',
          ),
          SizedBox(height: 12),
          TarjetaPago(
            concepto: 'Materiales',
            monto: '\$50',
            fecha: '10/04/2025',
            estado: 'Pagado',
          ),
        ],
      ),
    );
  }

  Widget _buildAulas() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Aulas Disponibles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TarjetaAula(
            nombre: 'Aula 101',
            capacidad: '30 estudiantes',
            equipamiento: 'Proyector, Pizarra',
          ),
          SizedBox(height: 12),
          TarjetaAula(
            nombre: 'Aula 102',
            capacidad: '25 estudiantes',
            equipamiento: 'Computadoras',
          ),
          SizedBox(height: 12),
          TarjetaAula(
            nombre: 'Lab. de Cómputo',
            capacidad: '20 estudiantes',
            equipamiento: 'PCs, Software especializado',
          ),
        ],
      ),
    );
  }
}

class TarjetaPago extends StatelessWidget {
  final String concepto, monto, fecha, estado;
  const TarjetaPago({
    super.key,
    required this.concepto,
    required this.monto,
    required this.fecha,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    final bool pagado = estado == 'Pagado';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(concepto, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Vence: $fecha', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(monto, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: pagado ? Colors.green.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  estado,
                  style: TextStyle(
                    fontSize: 12,
                    color: pagado ? Colors.green.shade900 : Colors.orange.shade900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TarjetaAula extends StatelessWidget {
  final String nombre, capacidad, equipamiento;
  const TarjetaAula({
    super.key,
    required this.nombre,
    required this.capacidad,
    required this.equipamiento,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text('Capacidad: $capacidad', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text('Equipamiento: $equipamiento', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}