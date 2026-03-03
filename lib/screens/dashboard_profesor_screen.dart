import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/widgets.dart';
import '../services/api_service.dart';

class DashboardProfesorScreen extends StatefulWidget {
  const DashboardProfesorScreen({super.key});

  @override
  State<DashboardProfesorScreen> createState() => _DashboardProfesorScreenState();
}

class _DashboardProfesorScreenState extends State<DashboardProfesorScreen> {
  int _tabSeleccionado = 1;
  List<dynamic> _horarios = [];
  List<dynamic> _alumnos = [];
  List<dynamic> _aulas = [];
  bool _cargando = true;
  String? _idProfesor;
  String? _nombreProfesor;
  String? _materiasProfesor;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    // Obtener datos del profesor del BLoC
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.usuario != null) {
      _idProfesor = authState.usuario!['id'].toString();
      _nombreProfesor = '${authState.usuario!['nombre']} ${authState.usuario!['apellidos']}';
      _materiasProfesor = authState.usuario!['materias_imparte'];
    }

    if (_idProfesor == null) {
      setState(() {
        _cargando = false;
      });
      return;
    }

    // Cargar datos en paralelo
    final idProf = int.parse(_idProfesor!);
    final resultHorarios = await ApiService.getProfesorHorarios(idProf);
    final resultAlumnos = await ApiService.getProfesorAlumnos(idProf);
    final resultAulas = await ApiService.getAulas();

    setState(() {
      _horarios = resultHorarios['horarios'] ?? [];
      _alumnos = resultAlumnos['alumnos'] ?? [];
      _aulas = resultAulas['aulas'] ?? [];
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: Column(
            children: [
              _buildHeader(state),
              _buildEstadisticas(),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prof. ${_nombreProfesor ?? "..."}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _materiasProfesor ?? "Cargando...",
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  // ignore: deprecated_member_use
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
    int clasesEstaSemana = _horarios.length;
    int totalAlumnos = _alumnos.length;
    int aulasDisponibles = _aulas.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Row(
        children: [
          Expanded(
            child: TarjetaEstadistica(
              icono: Icons.calendar_today,
              colorIcono: const Color(0xFF9333EA),
              colorFondoIcono: const Color(0xFFF5EEFF),
              etiqueta: 'Clases',
              valor: clasesEstaSemana.toString(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TarjetaEstadistica(
              icono: Icons.group,
              colorIcono: const Color(0xFF3B82F6),
              colorFondoIcono: const Color(0xFFEFF6FF),
              etiqueta: 'Alumnos',
              valor: totalAlumnos.toString(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TarjetaEstadistica(
              icono: Icons.domain,
              colorIcono: const Color(0xFF10B981),
              colorFondoIcono: const Color(0xFFECFDF5),
              etiqueta: 'Aulas',
              valor: aulasDisponibles.toString(),
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
          const Text('Mi Horario', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ..._horarios.map((horario) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TarjetaClaseProfesor(
              dia: horario['dia_semana'] ?? '',
              hora: '${horario['hora_inicio']} - ${horario['hora_fin']}',
              materia: horario['materia'] ?? 'Materia',
              aula: horario['aula_nombre'] ?? 'Aula',
              grupo: '${horario['alumno_nombre']} ${horario['alumno_apellidos']}',
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildListaAlumnos() {
    if (_alumnos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No hay alumnos registrados',
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
          const Text('Lista de Alumnos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ..._alumnos.map((alumno) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TarjetaAlumno(
              nombre: '${alumno['nombre']} ${alumno['apellidos']}',
              id: alumno['id_alumno'].toString(),
              curso: alumno['curso_actual'] ?? 'Curso',
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAulasProfesor() {
    if (_aulas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.domain, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No hay aulas disponibles',
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
          const Text('Aulas Disponibles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ..._aulas.map((aula) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TarjetaAulaProfesor(
              nombre: aula['nombre'] ?? 'Aula',
              capacidad: aula['capacidad']?.toString() ?? '0',
              equipamiento: aula['descripcion'] ?? 'Sin descripción',
              horario: 'Disponible',
            ),
          )),
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