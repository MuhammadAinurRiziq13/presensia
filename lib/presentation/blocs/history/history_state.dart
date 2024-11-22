import 'package:equatable/equatable.dart';
import 'package:presensia/domain/entities/absensi.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<AbsensiEntity> absensiList;

  var pegawai;

  HistoryLoaded({required this.absensiList});

  @override
  List<Object?> get props => [absensiList];
}

class HistoryFailure extends HistoryState {
  final String errorMessage;

  HistoryFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
