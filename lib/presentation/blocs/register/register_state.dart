import 'package:equatable/equatable.dart';
import 'package:presensia/domain/entities/pegawai.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final PegawaiEntity pegawai;

  RegisterSuccess(this.pegawai);

  @override
  List<Object?> get props => [pegawai];
}

class RegisterFailure extends RegisterState {
  final String errorMessage;

  RegisterFailure(this.errorMessage) : assert(errorMessage.isNotEmpty);

  @override
  List<Object?> get props => [errorMessage];
}

// Tambahkan state untuk upload gambar
class RegisterImageLoading
    extends RegisterState {} // State ketika upload gambar sedang dilakukan

class RegisterImageSuccess extends RegisterState {
  final Map<String, dynamic> response;

  RegisterImageSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class RegisterImageFailure extends RegisterState {
  final String errorMessage;

  RegisterImageFailure(this.errorMessage) : assert(errorMessage.isNotEmpty);

  @override
  List<Object?> get props => [errorMessage];
}
