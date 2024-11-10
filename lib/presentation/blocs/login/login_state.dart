import 'package:equatable/equatable.dart';
import '../../../domain/entities/pegawai.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final PegawaiEntity pegawai;

  LoginSuccess(this.pegawai);

  @override
  List<Object?> get props => [pegawai];
}

class LoginFailure extends LoginState {
  final String errorMessage;

  LoginFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
