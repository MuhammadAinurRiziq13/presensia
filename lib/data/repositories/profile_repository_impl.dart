import 'package:presensia/data/datasources/profile_api_datasource.dart';
import 'package:presensia/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiDataSource apiDataSource;

  ProfileRepositoryImpl(this.apiDataSource);

  @override
  Future<bool> changePassword(
      int idPegawai, String oldPassword, String newPassword) async {
    return await apiDataSource.updatePassword(
        idPegawai, oldPassword, newPassword);
  }
}
