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
      final pegawai = await _loginUseCase.execute(
        noPegawai: event.noPegawai,
        password: event.password,
      );

      // Simpan token ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = pegawai.token;
      if (token != null) {
        await prefs.setString('auth_token', token);
      }

      emit(LoginSuccess(pegawai));
    } catch (e) {
      if (e is DioException) {
        emit(LoginFailure(e.response?.data['message'] ?? 'Login failed'));
      } else {
        emit(LoginFailure("Terjadi kesalahan, coba lagi nanti."));
      }
    }
  }
}
