import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginAlumnoEvent extends AuthEvent {
  final String emailONombre;
  final String password;

  const LoginAlumnoEvent({
    required this.emailONombre,
    required this.password,
  });

  @override
  List<Object> get props => [emailONombre, password];
}

class LoginProfesorEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginProfesorEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  final bool isTeacher;

  const LoginEvent({
    required this.username,
    required this.password,
    required this.isTeacher,
  });

  @override
  List<Object> get props => [username, password, isTeacher];
}

class LogoutEvent extends AuthEvent {}
