import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:presensia/domain/usecases/get_today_attendance_usecase.dart';
import 'package:presensia/domain/usecases/get_user_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetTodaysAttendanceUseCase _getTodaysAttendanceUseCase;
  final GetUserUseCase _getUserUseCase;

  AttendanceBloc(this._getTodaysAttendanceUseCase, this._getUserUseCase)
      : super(AttendanceInitial()) {
    on<FetchAllDataEvent>(_onFetchAllDataEvent);
  }

  Future<void> _onFetchAllDataEvent(
    FetchAllDataEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final idPegawai = prefs.getInt('id_pegawai') ?? 0;

      if (idPegawai == 0) {
        emit(AttendanceFailure("Id Pegawai not found."));
        return;
      }

      // Fetch user data
      final user = await _getUserUseCase.execute(idPegawai);

      // Fetch attendance data
      final attendance = await _getTodaysAttendanceUseCase.execute(idPegawai);

      // Get today's date in Indonesian format
      final today =
          DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());

      emit(AttendanceAndUserSuccess(
        user: user,
        attendance: attendance,
        currentDate: today,
      ));
    } catch (e) {
      emit(AttendanceFailure("Error fetching data: ${e.toString()}"));
    }
  }
}
