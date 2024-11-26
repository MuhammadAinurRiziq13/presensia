import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:presensia/domain/usecases/get_user_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensia/domain/usecases/logout_usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserUseCase _getUserUseCase;
  final LogoutUseCase _logoutUseCase; // Tambahkan LogoutUseCase

  ProfileBloc(this._getUserUseCase, this._logoutUseCase)
      : super(ProfileInitial()) {
    on<FetchAllDataEvent>(_onFetchAllDataEvent);
    on<LogoutEvent>(_onLogoutEvent); // Tambahkan handler LogoutEvent
  }

  Future<void> _onFetchAllDataEvent(
    FetchAllDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final idPegawai = prefs.getInt('id_pegawai') ?? 0;

      if (idPegawai == 0) {
        emit(ProfileFailure("ID Pegawai not found."));
        return;
      }

      // Fetch user data
      final user = await _getUserUseCase.execute(idPegawai);
      emit(ProfileSuccess(user: user));
    } catch (e) {
      emit(ProfileFailure("Error fetching data: ${e.toString()}"));
    }
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _logoutUseCase.execute();
      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileFailure("Logout failed: ${e.toString()}"));
    }
  }
}
