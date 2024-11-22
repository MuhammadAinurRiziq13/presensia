import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
  @override
  List<Object?> get props => [];
}

class GetHistoryButtonPressed extends HistoryEvent {
  final int idPegawai;

  GetHistoryButtonPressed({required this.idPegawai});

  @override
  List<Object?> get props => [idPegawai];
}
