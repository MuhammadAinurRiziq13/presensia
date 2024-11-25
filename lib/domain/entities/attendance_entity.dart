import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:presensia/data/models/attendance_model.dart';

class AttendanceEntity extends Equatable {
  final int idAbsen;
  final int idPegawai;
  final String statusAbsen;
  final String lokasiAbsen;
  final String? fotoAbsen;
  final DateTime? tanggal;
  final DateTime? waktuMasuk;
  final DateTime? waktuKeluar;

  const AttendanceEntity({
    required this.idAbsen,
    required this.idPegawai,
    required this.statusAbsen,
    required this.lokasiAbsen,
    this.fotoAbsen,
    this.tanggal,
    this.waktuMasuk,
    this.waktuKeluar,
  });

  // Method to convert model to entity
  factory AttendanceEntity.fromModel(AttendanceModel model) {
    return AttendanceEntity(
      idAbsen: model.idAbsen,
      idPegawai: model.idPegawai,
      statusAbsen: model.statusAbsen,
      lokasiAbsen: model.lokasiAbsen,
      fotoAbsen: model.fotoAbsen,
      tanggal: model.tanggal,
      waktuMasuk: model.waktuMasuk,
      waktuKeluar: model.waktuKeluar,
    );
  }

  // Method to calculate total jam (hours worked)
  String get totalJam {
    if (waktuMasuk != null && waktuKeluar != null) {
      final duration = waktuKeluar!.difference(waktuMasuk!);
      final hours = duration.inHours;
      final minutes = (duration.inMinutes % 60);
      return '$hours jam $minutes menit';
    }
    return '___'; // Return "N/A" if either waktuMasuk or waktuKeluar is null
  }

  // Format DateTime to a readable string format
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('HH:mm').format(date);
  }

  @override
  List<Object?> get props => [
        idAbsen,
        idPegawai,
        statusAbsen,
        lokasiAbsen,
        fotoAbsen,
        tanggal,
        waktuMasuk,
        waktuKeluar,
      ];
}
