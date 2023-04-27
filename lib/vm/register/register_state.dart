import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterStateInitial extends RegisterState {
  const RegisterStateInitial();

  @override
  List<Object> get props => [];
}

class RegisterStateLoading extends RegisterState {
  const RegisterStateLoading();

  @override
  List<Object> get props => [];
}

class RegisterStateSuccess extends RegisterState {
  const RegisterStateSuccess();

  @override
  List<Object> get props => [];
}

class RegisterStateError extends RegisterState {
  final String error;

  const RegisterStateError(this.error);

  @override
  List<Object> get props => [];
}
