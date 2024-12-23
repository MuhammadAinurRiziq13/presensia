// import 'dart:io';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'presensi_event.dart';
// import 'presensi_state.dart';
// import 'package:presensia/domain/usecases/store_presensi_usecase.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PresensiBloc extends Bloc<PresensiEvent, PresensiState> {
//   final StorePresensiUseCase _storePresensiUseCase;

//   PresensiBloc(this._storePresensiUseCase) : super(PresensiInitial()) {
//     on<SubmitPresensiEvent>(_onSubmitPresensi);
//   }

//   Future<void> _onSubmitPresensi(
//     SubmitPresensiEvent event,
//     Emitter<PresensiState> emit,
//   ) async {
//     emit(PresensiLoading());

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final idPegawai = prefs.getInt('id_pegawai') ?? 0;

//       if (idPegawai == 0) {
//         emit(PresensiFailure(errorMessage: "Id Pegawai not found."));
//         return;
//       }

//       final result = await _storePresensiUseCase.execute(
//         idPegawai: idPegawai,
//         fotoAbsen: event.fotoAbsen,
//       );

//       // Simpan id_absensi ke SharedPreferences
//       await prefs.setInt('id_absensi', result.idAbsen);

//       print("Saved id_absensi: ${result.idAbsen}");

//       emit(PresensiSuccess(message: "Presensi berhasil disimpan"));
//     } catch (e) {
//       emit(PresensiFailure(errorMessage: "Error: ${e.toString()}"));
//     }
//   }
// }

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presensi_event.dart';
import 'presensi_state.dart';
import 'package:presensia/domain/usecases/store_presensi_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator
import 'package:dio/dio.dart';

class PresensiBloc extends Bloc<PresensiEvent, PresensiState> {
  final StorePresensiUseCase _storePresensiUseCase;

  PresensiBloc(this._storePresensiUseCase) : super(PresensiInitial()) {
    on<SubmitPresensiEvent>(_onSubmitPresensi);
  }

  Future<void> _onSubmitPresensi(
    SubmitPresensiEvent event,
    Emitter<PresensiState> emit,
  ) async {
    emit(PresensiLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final idPegawai = prefs.getInt('id_pegawai') ?? 0;

      if (idPegawai == 0) {
        emit(PresensiFailure("Id Pegawai not found."));
        return;
      }

      // Cek apakah latitude dan longitude ada, jika tidak, gunakan nilai default
      double latitude = event.latitude ?? 0.0; // Nilai default jika null
      double longitude = event.longitude ?? 0.0; // Nilai default jika null

      // Lokasi yang ditentukan (misalnya lokasi kantor)
      const kantorLatitude = -7.9495479; // Latitude kantor
      const kantorLongitude = 112.6219271; // Longitude kantor

      // Hitung jarak antara lokasi pengguna dan kantor
      double distanceInMeters = await Geolocator.distanceBetween(
        latitude,
        longitude,
        kantorLatitude,
        kantorLongitude,
      );

      // Cek apakah jaraknya dalam radius 100m
      if (distanceInMeters <= 100) {
        final result = await _storePresensiUseCase.execute(
          idPegawai: idPegawai,
          fotoAbsen: event.fotoAbsen,
          lokasiAbsen: event.lokasiAbsen,
        );

        // Simpan id_absensi ke SharedPreferences
        await prefs.setInt('id_absensi', result.idAbsen);

        print("Saved id_absensi: ${result.idAbsen}");

        emit(PresensiSuccess("Presensi berhasil disimpan"));
      } else {
        emit(PresensiFailure(
            "Anda tidak berada dalam radius 100m dari lokasi yang ditentukan."));
      }
    } catch (e) {
      if (e is DioException) {
        emit(PresensiFailure(e.response?.data['message'] ?? 'Login failed'));
      } else {
        emit(PresensiFailure("Terjadi kesalahan, coba lagi nanti."));
      }
    }
  }

  // Fungsi untuk menghitung jarak antara dua titik koordinat
  Future<double> _calculateDistance(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) async {
    // Menggunakan Geolocator untuk menghitung jarak antara dua koordinat
    double distance = await Geolocator.distanceBetween(
      latitude1,
      longitude1,
      latitude2,
      longitude2,
    );
    return distance;
  }
}
