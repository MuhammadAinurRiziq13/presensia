import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:presensia/domain/usecases/get_user_usecase.dart';
import 'package:presensia/domain/usecases/change_password_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetailBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserUseCase _getUserUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  ProfileDetailBloc(this._getUserUseCase, this._changePasswordUseCase)
      : super(ProfileInitial()) {
    on<FetchAllDataEvent>(_onFetchAllDataEvent);
    on<ChangePasswordEvent>(_onChangePasswordEvent);
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

  Future<void> _onChangePasswordEvent(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfilePasswordLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final idPegawai = prefs.getInt('id_pegawai') ?? 0;

      if (idPegawai == 0) {
        emit(ProfilePasswordChangeFailure("ID Pegawai not found."));
        return;
      }

      // Attempt to change password
      final success = await _changePasswordUseCase.execute(
        idPegawai,
        event.oldPassword,
        event.newPassword,
      );

      if (success) {
        emit(ProfilePasswordChangeSuccess());
      } else {
        emit(ProfilePasswordChangeFailure("Failed to change password"));
      }
    } catch (e) {
      emit(ProfilePasswordChangeFailure("Failed to change password"));
    }
  }
}
