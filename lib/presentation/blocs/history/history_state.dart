import 'package:equatable/equatable.dart';
import 'package:presensia/domain/entities/absensi.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistorySuccess extends HistoryState {
  final List<AbsensiEntity> history;

  HistorySuccess({
    required this.history,
  });

  @override
  List<Object?> get props => [history];
}

class HistoryFailure extends HistoryState {
  final String errorMessage;

  HistoryFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
