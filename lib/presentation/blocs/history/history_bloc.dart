import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_event.dart';
import 'history_state.dart';
import 'package:presensia/domain/usecases/history_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase getHistoryUseCase;

  HistoryBloc(this.getHistoryUseCase) : super(HistoryInitial()) {
    on<GetHistoryButtonPressed>(_onGetHistoryButtonPressed);
  }
  Future<void> _onGetHistoryButtonPressed(
    GetHistoryButtonPressed event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final idPegawai = prefs.getInt('id_pegawai') ?? 0;

      if (idPegawai == 0) {
        emit(HistoryFailure("Id Pegawai not found."));
        return;
      }

      // Fetch user data
      final history = await getHistoryUseCase.execute(idPegawai);

      emit(HistorySuccess(
        history: history,
      ));
    } catch (e) {
      emit(HistoryFailure("Error fetching data: ${e.toString()}"));
    }
  }
}
