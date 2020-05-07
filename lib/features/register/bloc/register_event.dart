import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String fullName;
  final String email;
  final String password;

  const RegisterSubmitted({
    @required this.fullName,
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [fullName, email, password];

  @override
  String toString() {
    return 'RegisterSubmitted { fullName: $fullName, email: $email, password: $password }';
  }
}
