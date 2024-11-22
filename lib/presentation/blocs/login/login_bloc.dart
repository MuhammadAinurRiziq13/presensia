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

      // Simpan token dan ID Pegawai ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = pegawai.token;
      final idPegawai = pegawai.id;

      if (token != null && idPegawai != null) {
        await prefs.setString('auth_token', token);
        await prefs.setInt('id_pegawai', idPegawai);
        print("Token dan ID Pegawai berhasil disimpan: $token, $idPegawai");
      } else {
        print(
            "Peringatan: Token atau ID Pegawai tidak ditemukan dari response API.");
      }

      emit(LoginSuccess(pegawai));
    } catch (e) {
      if (e is DioException) {
        emit(LoginFailure(e.response?.data['message'] ?? 'Login failed'));
      } else {
        emit(LoginFailure("Terjadi kesalahan: ${e.toString()}"));
      }
    }
  }
}




// (KODE LAMA : RIZIQ)
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../domain/usecases/login_usecase.dart';
// import 'login_event.dart';
// import 'login_state.dart';
// import 'package:dio/dio.dart';

// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   final LoginUseCase _loginUseCase;

//   LoginBloc(this._loginUseCase) : super(LoginInitial()) {
//     on<LoginButtonPressed>(_onLoginButtonPressed);
//   }

//   Future<void> _onLoginButtonPressed(
//     LoginButtonPressed event,
//     Emitter<LoginState> emit,
//   ) async {
//     emit(LoginLoading());

//     try {
//       final pegawai = await _loginUseCase.execute(
//         noPegawai: event.noPegawai,
//         password: event.password,
//       );

//       // Simpan token ke SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final token = pegawai.token;
//       if (token != null) {
//         await prefs.setString('auth_token', token);
//       }

//       emit(LoginSuccess(pegawai));
//     } catch (e) {
//       if (e is DioException) {
//         emit(LoginFailure(e.response?.data['message'] ?? 'Login failed'));
//       } else {
//         emit(LoginFailure("Terjadi kesalahan, coba lagi nanti."));
//       }
//     }
//   }
// }
