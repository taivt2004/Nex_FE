import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterButtonPressed extends RegisterEvent {
  RegisterButtonPressed({required this.username, required this.password});
  final String username;
  final String password;

  @override
  List<Object?> get props => [username, password];
}
