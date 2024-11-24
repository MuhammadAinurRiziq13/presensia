import 'package:flutter_bloc/flutter_bloc.dart';
import 'permit_event.dart';
import 'permit_state.dart';
import '../../../data/repositories/permit_repository.dart';

class PermitBloc extends Bloc<PermitEvent, PermitState> {
  final PermitRepository repository;

  PermitBloc(this.repository) : super(PermitInitial()) {
    on<FetchPermits>((event, emit) async {
      emit(PermitLoading());
      try {
        final permits = await repository.fetchPermits();
        emit(PermitLoaded(permits));
      } catch (e) {
        emit(PermitError(e.toString()));
      }
    });

    on<CreatePermit>((event, emit) async {
      try {
        await repository.createPermit(event.permit);
        add(FetchPermits()); // Refresh data
      } catch (e) {
        emit(PermitError(e.toString()));
      }
    });

    on<ApprovePermit>((event, emit) async {
      try {
        await repository.approvePermit(event.id);
        add(FetchPermits());
      } catch (e) {
        emit(PermitError(e.toString()));
      }
    });

    on<RejectPermit>((event, emit) async {
      try {
        await repository.rejectPermit(event.id);
        add(FetchPermits());
      } catch (e) {
        emit(PermitError(e.toString()));
      }
    });
  }
}
