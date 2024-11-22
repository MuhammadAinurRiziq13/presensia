import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensia/domain/usecases/history_usecase.dart';
import 'package:presensia/presentation/blocs/history/history_event.dart';
import 'package:presensia/presentation/blocs/history/history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase _getHistoryUseCase;

  HistoryBloc(this._getHistoryUseCase) : super(HistoryInitial()) {
    on<GetHistoryButtonPressed>(_onGetHistoryButtonPressed);
  }

  Future<void> _onGetHistoryButtonPressed(
      GetHistoryButtonPressed event, Emitter<HistoryState> emit) async {
    print(
        'Menerima event GetHistoryButtonPressed dengan ID Pegawai: ${event.idPegawai}');

    try {
      emit(HistoryLoading()); // Menampilkan loading saat mengambil data
      final absensiList = await _getHistoryUseCase.execute(event.idPegawai);

      print('Data history berhasil dimuat: ${absensiList.length} item');

      emit(HistoryLoaded(absensiList: absensiList)); // Data berhasil dimuat
    } catch (e) {
      print('Error saat mengambil data history: $e');
      emit(HistoryFailure(errorMessage: e.toString())); // Menangani error
    }
  }
}
