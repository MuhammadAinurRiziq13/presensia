import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:dio/dio.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      // Execute login
      final pegawai = await _loginUseCase.execute(
        noPegawai: event.noPegawai,
        password: event.password,
      );

      // Store token and idPegawai to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = pegawai.token;
      if (token != null) {
        await prefs.setString('auth_token', token);
      }
      final idPegawai = pegawai.id ?? 0;
      await prefs.setInt('id_pegawai', idPegawai); // Store idPegawai

      // Debugging: Print the idPegawai
      print('Debugging - idPegawai: ${idPegawai}');

      emit(LoginSuccess(pegawai)); // Return success with pegawai data
    } catch (e) {
      if (e is DioException) {
        emit(LoginFailure(e.response?.data['message'] ?? 'Login failed'));
      } else {
        emit(LoginFailure("Terjadi kesalahan, coba lagi nanti."));
      }
    }
  }
}
