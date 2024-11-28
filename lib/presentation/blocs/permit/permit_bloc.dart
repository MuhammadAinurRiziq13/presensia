import 'package:flutter_bloc/flutter_bloc.dart';
import 'permit_event.dart';
import 'permit_state.dart';
import 'package:presensia/domain/usecases/permit_usecase.dart';
import 'package:presensia/domain/entities/permit.dart';

class PermitBloc extends Bloc<PermitEvent, PermitState> {
  final PermitUseCase permitUseCase;

  PermitBloc(this.permitUseCase) : super(PermitInitialState());

  @override
  Stream<PermitState> mapEventToState(PermitEvent event) async* {
    if (event is GetPermitsEvent) {
      yield PermitLoadingState();
      try {
        final permits = await permitUseCase.getPermits(event.idPegawai);
        yield PermitLoadedState(permits);
      } catch (e) {
        yield PermitErrorState(e.toString());
      }
    }

    if (event is SubmitPermitEvent) {
      yield PermitLoadingState();
      try {
        final permit = await permitUseCase.submitPermit(
          idPegawai: event.idPegawai,
          jenisIzin: event.jenisIzin,
          keterangan: event.keterangan,
          tanggalMulai: event.tanggalMulai,
          tanggalAkhir: event.tanggalAkhir,
          dokumen: event.dokumen,
        );
        yield PermitSubmittedState(permit);
      } catch (e) {
        yield PermitErrorState(e.toString());
      }
    }
  }
}
