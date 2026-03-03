import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/widgets.dart';
import '../services/api_service.dart';

class DashboardAlumnoScreen extends StatefulWidget {
  const DashboardAlumnoScreen({super.key});

  @override
  State<DashboardAlumnoScreen> createState() => _DashboardAlumnoScreenState();
}

class _DashboardAlumnoScreenState extends State<DashboardAlumnoScreen> {
  int _tabSeleccionado = 0;
  List<dynamic> _horarios = [];
  List<dynamic> _recibos = [];
  bool _cargando = true;
  String? _idAlumno;
  String? _nombreAlumno;
  String? _cursoAlumno;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    // Obtener datos del alumno del BLoC
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.usuario != null) {
      _idAlumno = authState.usuario!['id'].toString();
      _nombreAlumno = authState.usuario!['nombre'];
      _cursoAlumno = authState.usuario!['curso_actual'];
    }

    if (_idAlumno == null) {
      setState(() {
        _cargando = false;
      });
      return;
    }

    // Cargar datos en paralelo
    final idAlumn = int.parse(_idAlumno!);
    final resultHorarios = await ApiService.getAlumnoHorarios(idAlumn);
    final resultRecibos = await ApiService.getAlumnoRecibos(idAlumn);

    setState(() {
      _horarios = resultHorarios['horarios'] ?? [];
      _recibos = resultRecibos['recibos'] ?? [];
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FBFE),
          body: Column(
            children: [
              _buildHeader(state),
              Expanded(
                child: _cargando ? _buildCargando() : _buildContenidoSegunTab(),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildCargando() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildHeader(AuthState state) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_nombreAlumno ?? "Cargando...",
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('ID: ${_idAlumno ?? "..."}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(_cursoAlumno ?? "",
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
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
      ],
    );
  }

  Widget _buildContenidoSegunTab() {
    switch (_tabSeleccionado) {
      case 0:
        return _buildHorario();
      case 1:
        return _buildPagos();
      default:
        return _buildHorario();
    }
  }

  Widget _buildHorario() {
    if (_horarios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No hay horarios registrados',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Horario de Clases', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ..._horarios.map((horario) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TarjetaClase(
              dia: horario['dia_semana'] ?? '',
              hora: '${horario['hora_inicio']} - ${horario['hora_fin']}',
              materia: horario['materia'] ?? 'Materia',
              aula: horario['aula_nombre'] ?? 'Aula',
              color: const Color(0xFF05A3C7),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPagos() {
    if (_recibos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No hay recibos registrados',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Estado de Pagos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ..._recibos.map((recibo) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TarjetaPago(
              concepto: recibo['mes'] ?? 'Pago',
              monto: '\$${recibo['importe']}',
              fecha: _formatearFecha(recibo['fecha_emision']),
              estado: recibo['estado'] ?? 'Desconocido',
            ),
          )),
        ],
      ),
    );
  }

  String _formatearFecha(String? fecha) {
    if (fecha == null || fecha.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(fecha);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return fecha;
    }
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