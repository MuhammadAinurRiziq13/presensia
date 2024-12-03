import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensia/domain/entities/pegawai.dart';
import 'package:presensia/domain/usecases/register_usecase.dart';
import 'package:presensia/domain/usecases/register_image_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_event.dart';
import 'register_state.dart';
import 'package:dio/dio.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;
  final RegisterImageUseCase _registerImageUseCase;

  RegisterBloc(this._registerUseCase, this._registerImageUseCase)
      : super(RegisterInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
    on<RegisterImageEvent>(_onRegisterImageEvent);
  }

  Future<void> _onRegisterButtonPressed(
    RegisterButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    try {
      // Panggil use case register
      final PegawaiEntity pegawai = await _registerUseCase.execute(
        noPegawai: event.noPegawai,
        alamat: event.alamat,
        noHp: event.noHp,
        password: event.password,
      );

      // Store token and idPegawai to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final idPegawai = pegawai.id ?? 0;
      await prefs.setInt('id_pegawai', idPegawai); // Store idPegawai

      // Debugging: Print the idPegawai
      print('Debugging - idPegawai: ${idPegawai}');

      // Emit success dengan data pegawai
      emit(RegisterSuccess(pegawai));
    } catch (e) {
      // Penanganan error
      if (e is DioException) {
        final errorResponse = e.response?.data;
        final errorMessage = errorResponse != null
            ? (errorResponse['message'] ?? 'Register gagal, coba lagi')
            : 'Register gagal, coba lagi';

        emit(RegisterFailure(errorMessage));
      } else {
        emit(RegisterFailure("Nomor pegawai tidak terdaftar, register gagal"));
      }
    }
  }

  // Handle Register Image Upload Event
  Future<void> _onRegisterImageEvent(
    RegisterImageEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterImageLoading());

    try {
      // Ambil id_pegawai dari SharedPreferences setelah registrasi
      final prefs = await SharedPreferences.getInstance();
      final idPegawai = prefs.getInt('id_pegawai') ?? 0;

      if (idPegawai == 0) {
        emit(RegisterImageFailure("Id Pegawai tidak ditemukan."));
        return;
      }

      // Panggil method upload gambar dari repository
      final response = await _registerImageUseCase.execute(
        idPegawai: idPegawai,
        files: event.files,
      );

      emit(RegisterImageSuccess(
          response)); // Jika berhasil, emit success dengan response
    } catch (e) {
      if (e is DioException) {
        final errorResponse = e.response?.data;
        final errorMessage = errorResponse != null
            ? (errorResponse['message'] ?? 'Gagal mengupload gambar')
            : 'Gagal mengupload gambar, coba lagi!';
        emit(RegisterImageFailure(errorMessage));
      } else {
        emit(RegisterImageFailure("error else"));
      }
    }
  }
}
