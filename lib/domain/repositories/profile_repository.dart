abstract class ProfileRepository {
  Future<bool> changePassword(
      int idPegawai, String oldPassword, String newPassword);
}
