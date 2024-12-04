import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'permit_event.dart';
import 'permit_state.dart';
import 'package:presensia/domain/usecases/permit_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermitsBloc extends Bloc<PermitEvent, PermitState> {
  final PermitUseCase permitUseCase;

  PermitsBloc(this.permitUseCase) : super(PermitInitialState()) {
    on<GetPermitsEvent>(_onGetPermitsButtonPressed);
    on<SubmitPermitEvent>(_onSubmitPermit); // Handler untuk submit izin
  }

  Future<void> _onGetPermitsButtonPressed(
    GetPermitsEvent event,
    Emitter<PermitState> emit,
  ) async {
    emit(PermitLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final idPegawai = prefs.getInt('id_pegawai') ?? 0;

      if (idPegawai == 0) {
        emit(PermitFailure("Id Pegawai not found."));
        return;
      }

      // Fetch user data
      final permits = await permitUseCase.execute(idPegawai);

      emit(PermitSuccess(permits: permits));
    } catch (e) {
      emit(PermitFailure("Error fetching data: ${e.toString()}"));
    }
  }

  Future<void> _onSubmitPermit(
    SubmitPermitEvent event,
    Emitter<PermitState> emit,
  ) async {
    emit(PermitLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final dokumen = event.jenisIzin == 'Sakit' ? event.dokumen : null;
      final idPegawai = prefs.getInt('id_pegawai') ?? 0;

      final permit = await permitUseCase.submitPermit(
        idPegawai: idPegawai,
        jenisIzin: event.jenisIzin,
        keterangan: event.keterangan,
        tanggalMulai: event.tanggalMulai,
        tanggalAkhir: event.tanggalAkhir,
        dokumen: dokumen,
      );

      emit(PermitSubmittedState(permit));
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data ?? 'Unknown error';
        emit(PermitFailure("Error submitting permit: $errorMessage"));
      } else {
        emit(PermitFailure("Error submitting permit: ${e.toString()}"));
      }
    }
  }
}
