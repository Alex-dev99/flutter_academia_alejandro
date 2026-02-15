import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
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
