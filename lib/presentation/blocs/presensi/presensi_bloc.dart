import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presensi_event.dart';
import 'presensi_state.dart';
import 'package:presensia/domain/usecases/store_presensi_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PresensiBloc extends Bloc<PresensiEvent, PresensiState> {
  final StorePresensiUseCase _storePresensiUseCase;

  PresensiBloc(this._storePresensiUseCase) : super(PresensiInitial()) {
    on<SubmitPresensiEvent>(_onSubmitPresensi);
  }

  Future<void> _onSubmitPresensi(
    SubmitPresensiEvent event,
    Emitter<PresensiState> emit,
  ) async {
    emit(PresensiLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final idPegawai = prefs.getInt('id_pegawai') ?? 0;

      if (idPegawai == 0) {
        emit(PresensiFailure(errorMessage: "Id Pegawai not found."));
        return;
      }

      final result = await _storePresensiUseCase.execute(
        idPegawai: idPegawai,
        fotoAbsen: event.fotoAbsen,
      );

      // Simpan id_absensi ke SharedPreferences
      await prefs.setInt('id_absensi', result.idAbsen);

      print("Saved id_absensi: ${result.idAbsen}");

      emit(PresensiSuccess(message: "Presensi berhasil disimpan"));
    } catch (e) {
      emit(PresensiFailure(errorMessage: "Error: ${e.toString()}"));
    }
  }
}
