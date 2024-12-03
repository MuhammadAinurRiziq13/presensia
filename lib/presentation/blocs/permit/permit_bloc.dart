import 'package:flutter_bloc/flutter_bloc.dart';
import 'permit_event.dart';
import 'permit_state.dart';
import 'package:presensia/domain/usecases/permit_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensia/domain/entities/permit.dart';

class PermitsBloc extends Bloc<PermitEvent, PermitState> {
  final PermitUseCase getPermitsUseCase;

  PermitsBloc(this.getPermitsUseCase) : super(PermitInitialState()) {
    on<GetPermitsEvent>(_onGetPermitsButtonPressed);
  }
  Future<void> _onGetPermitsButtonPressed(
    GetPermitsEvent event,
    Emitter<PermitState> emit,
  ) async {
    emit(PermitLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final idPegawai = prefs.getInt('id_pegawai') ?? 0;

      if (idPegawai == 0) {
        emit(PermitFailure("Id Pegawai not found."));
        return;
      }

      // Fetch user data
      final permit = await getPermitsUseCase.execute(idPegawai);

      emit(PermitSuccess(
        permits: permit,
      ));
    } catch (e) {
      emit(PermitFailure("Error fetching data: ${e.toString()}"));
    }
  }
}


// class PermitBloc extends Bloc<PermitEvent, PermitState> {
//   final PermitUseCase permitUseCase;

//   PermitBloc(this.permitUseCase) : super(PermitInitialState());

//   @override
//   Stream<PermitState> mapEventToState(PermitEvent event) async* {
//     if (event is GetPermitsEvent) {
//       yield PermitLoadingState();
//       try {
//         final permits = await permitUseCase.execute(event.idPegawai);
//         yield PermitSuccess(permits);
//       } catch (e) {
//         yield PermitFailure(e.toString());
//       }
//     }

//     if (event is SubmitPermitEvent) {
//       yield PermitLoadingState();
//       try {
//         final permit = await permitUseCase.submitPermit(
//           idPegawai: event.idPegawai,
//           jenisIzin: event.jenisIzin,
//           keterangan: event.keterangan,
//           tanggalMulai: event.tanggalMulai,
//           tanggalAkhir: event.tanggalAkhir,
//           dokumen: event.dokumen,
//         );
//         yield PermitSubmittedState(permit);
//       } catch (e) {
//         yield PermitFailure(e.toString());
//       }
//     }
//   }
// }
