import '../../domain/entities/absensi.dart';
import '../../domain/repositories/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository _historyRepository;

  // Menerima HistoryRepository melalui konstruktor
  GetHistoryUseCase(this._historyRepository);

  Future<List<AbsensiEntity>> execute(int idPegawai) async {
    return await _historyRepository.getHistory(idPegawai);
  }
}
