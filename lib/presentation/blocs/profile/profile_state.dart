import 'package:equatable/equatable.dart';
import 'package:presensia/domain/entities/pegawai.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final PegawaiEntity user;

  const ProfileSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileFailure extends ProfileState {
  final String errorMessage;

  const ProfileFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// Menambahkan state untuk perubahan password
class ProfilePasswordChangeSuccess extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfilePasswordChangeFailure extends ProfileState {
  final String errorMessage;

  const ProfilePasswordChangeFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ProfilePasswordLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}
