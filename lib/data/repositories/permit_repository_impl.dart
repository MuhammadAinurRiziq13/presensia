import 'dart:io';
import '../datasources/permit_api_datasource.dart';
import '../../domain/entities/permit.dart';
import '../../domain/repositories/permit_repository.dart';

class PermitRepositoryImpl implements PermitRepository {
  final PermitApiDataSource _permitApiDataSource;

  PermitRepositoryImpl(this._permitApiDataSource);

  @override
  Future<List<PermitEntity>> getPermits(int idPegawai) async {
    try {
      // Fetch data from data source (List<PermitModel>)
      final permitModels = await _permitApiDataSource.getPermits(idPegawai);

      // Convert List<PermitModel> to List<PermitEntity>
      return permitModels
          .map((model) => PermitEntity.fromModel(model))
          .toList();
    } catch (e) {
      print('Error fetching permits: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<PermitEntity> submitPermit({
    required int idPegawai,
    required String jenisIzin,
    required String keterangan,
    required DateTime tanggalMulai,
    required DateTime tanggalAkhir,
    File? dokumen,
  }) async {
    final permitModel = await _permitApiDataSource.submitPermit(
      idPegawai: idPegawai,
      jenisIzin: jenisIzin,
      keterangan: keterangan,
      tanggalMulai: tanggalMulai,
      tanggalAkhir: tanggalAkhir,
      dokumen: dokumen,
    );

    // Return the PermitEntity converted from PermitModel
    return PermitEntity.fromModel(permitModel);
  }
}
