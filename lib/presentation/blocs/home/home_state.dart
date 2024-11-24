import 'package:equatable/equatable.dart';
import 'package:presensia/domain/entities/attendance_entity.dart';
import 'package:presensia/domain/entities/pegawai.dart';

abstract class AttendanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceAndUserSuccess extends AttendanceState {
  final PegawaiEntity user;
  final List<AttendanceEntity> attendance;
  final String currentDate;

  AttendanceAndUserSuccess({
    required this.user,
    required this.attendance,
    required this.currentDate,
  });

  @override
  List<Object?> get props => [user, attendance, currentDate];
}

class AttendanceFailure extends AttendanceState {
  final String errorMessage;

  AttendanceFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
