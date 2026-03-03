import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String username;
  final bool isTeacher;
  final Map<String, dynamic>? usuario; // Información completa del usuario

  const AuthAuthenticated({
    required this.username,
    required this.isTeacher,
    this.usuario,
  });

  @override
  List<Object> get props => [username, isTeacher, usuario ?? {}];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
