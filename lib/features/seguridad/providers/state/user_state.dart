import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final String? nombre;
  final String? apellido;
  final String? email;

  const UserState({this.nombre, this.apellido, this.email});

  @override
  List<Object?> get props => [nombre, apellido, email];
}

class InitialUserState extends UserState {}

class AuthenticatedUserState extends UserState {
  const AuthenticatedUserState(
      {required String nombre, required String apellido, required String email})
      : super(nombre: nombre, apellido: apellido, email: email);
}

class UnauthenticatedUserState extends UserState {}
