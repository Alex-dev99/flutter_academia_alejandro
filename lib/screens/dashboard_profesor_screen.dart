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
  int _tabSeleccionado = 0;
  List<dynamic> _horarios = [];
  List<dynamic> _alumnos = [];
  List<dynamic> _aulas = [];
  bool _cargando = true;
  String? _idProfesor;
  String? _nombreProfesor;
  String? _materiasProfesor;
  DateTime _fechaSeleccionada = DateTime.now();

  String _getDiaSemanaString(DateTime date) {
    const dias = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];
    return dias[date.weekday - 1];
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (fecha != null && fecha != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
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
    final String diaSemana = _getDiaSemanaString(_fechaSeleccionada);
    final List<dynamic> horariosDelDia = _horarios.where((h) {
      final String dia = h['dia_semana']?.toString() ?? '';
      return dia.trim().toLowerCase() == diaSemana.toLowerCase();
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mi horario de Hoy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              InkWell(
                onTap: () => _seleccionarFecha(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${_fechaSeleccionada.day.toString().padLeft(2, '0')}/${_fechaSeleccionada.month.toString().padLeft(2, '0')}/${_fechaSeleccionada.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.keyboard_arrow_down, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: horariosDelDia.map((h) {
                      String hora = h['hora_inicio']?.toString() ?? '';
                      if (hora.length >= 5) hora = hora.substring(0, 5);
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B7280),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          hora,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
            ),
            child: Text(
              diaSemana.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
            ),
          ),
          const SizedBox(height: 16),
          if (horariosDelDia.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Icon(Icons.calendar_today, size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'No hay clases programadas para este día',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          else
            ...horariosDelDia.map((horario) => TarjetaClaseProfesor(
              horaInicio: horario['hora_inicio']?.toString() ?? '',
              horaFin: horario['hora_fin']?.toString() ?? '',
              alumno: '${horario['alumno_nombre']} ${horario['alumno_apellidos']}',
              materia: horario['materia']?.toString() ?? 'Materia',
              aula: horario['aula_nombre']?.toString() ?? 'Aula',
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
  final String horaInicio, horaFin, alumno, materia, aula;
  const TarjetaClaseProfesor({
    super.key,
    required this.horaInicio,
    required this.horaFin,
    required this.alumno,
    required this.materia,
    required this.aula,
  });

  @override
  Widget build(BuildContext context) {
    String horaFormateada = horaInicio;
    if (horaInicio.length >= 5) {
      horaFormateada = horaInicio.substring(0, 5);
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF6B7280),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              horaFormateada,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    alumno,
                    style: const TextStyle(
                      fontSize: 16, 
                      color: Colors.green,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.person, color: Colors.green, size: 20),
              ],
            ),
          ),
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