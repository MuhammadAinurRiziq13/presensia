import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:presensia/domain/usecases/get_today_attendance_usecase.dart';
import 'package:presensia/domain/usecases/get_user_usecase.dart';
import 'package:presensia/domain/usecases/get_quota_usecase.dart';
import 'package:presensia/domain/usecases/update_waktu_keluar_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetTodaysAttendanceUseCase _getTodaysAttendanceUseCase;
  final GetUserUseCase _getUserUseCase;
  final GetRemainingQuotaUseCase _getRemainingQuotaUseCase;
  final UpdateWaktuKeluarUseCase _updateWaktuKeluarUseCase;

  AttendanceBloc(
    this._getTodaysAttendanceUseCase,
    this._getUserUseCase,
    this._getRemainingQuotaUseCase,
    this._updateWaktuKeluarUseCase,
  ) : super(AttendanceInitial()) {
    on<FetchAllDataEvent>(_onFetchAllDataEvent);
    on<UpdateWaktuKeluarEvent>(_onUpdateWaktuKeluarEvent);
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

      // Fetch remaining quota data (jatah WFA & cuti)
      final quota = await _getRemainingQuotaUseCase.execute(idPegawai);

      // Get today's date in Indonesian format
      final today =
          DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());

      print(
          'Quota Data in Bloc: sisaSakit=${quota.sisaSakit}, sisaCuti=${quota.sisaCuti}');

      if (attendance.isNotEmpty) {
        // Mengambil idAbsen dari attendance pertama
        int idAbsenFirst = attendance.first.idAbsen;

        // Menyimpan idAbsen yang pertama ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id_absensi', idAbsenFirst);
      }

      emit(AttendanceAndUserSuccess(
        user: user,
        attendance: attendance,
        currentDate: today,
        sisaSakit: quota.sisaSakit, // Pastikan ini tidak null
        sisaCuti: quota.sisaCuti, // Pastikan ini tidak null
      ));
    } catch (e) {
      emit(AttendanceFailure("Error fetching data: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateWaktuKeluarEvent(
    UpdateWaktuKeluarEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final idAbsensi = prefs.getInt('id_absensi') ?? 0;

      if (idAbsensi == 0) {
        emit(AttendanceFailure("Id Absensi not found."));
        return;
      }

      // Jalankan use case untuk memperbarui waktu_keluar
      final updatedAttendance =
          await _updateWaktuKeluarUseCase.execute(idAbsensi);

      emit(AttendanceUpdateSuccess(attendance: updatedAttendance));

      // Panggil ulang data setelah berhasil
      add(FetchAllDataEvent());
    } catch (e) {
      emit(AttendanceFailure("Error updating waktu keluar: ${e.toString()}"));
    }
  }
}
