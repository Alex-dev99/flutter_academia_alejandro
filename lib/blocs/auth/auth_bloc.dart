import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
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
