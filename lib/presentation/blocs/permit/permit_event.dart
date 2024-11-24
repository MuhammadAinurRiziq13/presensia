import 'package:equatable/equatable.dart';
import '../../../data/models/permit_model.dart';

abstract class PermitEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPermits extends PermitEvent {}

class CreatePermit extends PermitEvent {
  final Permit permit;

  CreatePermit(this.permit);

  @override
  List<Object?> get props => [permit];
}

class ApprovePermit extends PermitEvent {
  final int id;

  ApprovePermit(this.id);

  @override
  List<Object?> get props => [id];
}

class RejectPermit extends PermitEvent {
  final int id;

  RejectPermit(this.id);

  @override
  List<Object?> get props => [id];
}
