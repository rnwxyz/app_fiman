part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthLogin extends AuthEvent {
  final String name;

  AuthLogin(this.name);
}

class AuthCheck extends AuthEvent {}

class AuthLogout extends AuthEvent {}
