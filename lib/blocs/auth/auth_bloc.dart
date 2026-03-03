import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginAlumnoEvent>(_onLoginAlumno);
    on<LoginProfesorEvent>(_onLoginProfesor);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoginAlumno(LoginAlumnoEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final result = await ApiService.loginAlumno(
        emailONombre: event.emailONombre,
        password: event.password,
      );

      if (result['success'] == true) {
        final usuario = result['usuario'] as Map<String, dynamic>;
        emit(AuthAuthenticated(
          username: usuario['nombre'] ?? '',
          isTeacher: false,
          usuario: usuario,
        ));
      } else {
        emit(AuthError(result['message'] ?? 'Error en la autenticación'));
      }
    } catch (e) {
      emit(AuthError('Error: $e'));
    }
  }

  Future<void> _onLoginProfesor(LoginProfesorEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final result = await ApiService.loginProfesor(
        email: event.email,
        password: event.password,
      );

      if (result['success'] == true) {
        final usuario = result['usuario'] as Map<String, dynamic>;
        emit(AuthAuthenticated(
          username: usuario['nombre'] ?? '',
          isTeacher: true,
          usuario: usuario,
        ));
      } else {
        emit(AuthError(result['message'] ?? 'Error en la autenticación'));
      }
    } catch (e) {
      emit(AuthError('Error: $e'));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    await Future.delayed(const Duration(seconds: 1));
    
    if (event.username.isNotEmpty && event.password.isNotEmpty) {
      emit(AuthAuthenticated(
        username: event.username,
        isTeacher: event.isTeacher,
      ));
    } else {
      emit(const AuthError('Credenciales inválidas'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthUnauthenticated());
  }
}
