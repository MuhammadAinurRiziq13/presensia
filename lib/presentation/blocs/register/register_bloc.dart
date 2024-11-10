import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensia/domain/entities/pegawai.dart';
import 'package:presensia/domain/usecases/register_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';
import 'package:dio/dio.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc(this._registerUseCase) : super(RegisterInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
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
}
