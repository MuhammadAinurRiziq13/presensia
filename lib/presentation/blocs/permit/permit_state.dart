import 'package:equatable/equatable.dart';
import 'package:presensia/domain/entities/permit.dart';

abstract class PermitState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PermitInitialState extends PermitState {}

class PermitLoadingState extends PermitState {}

class PermitLoadedState extends PermitState {
  final List<PermitEntity> permits;

  PermitLoadedState(this.permits);

  @override
  List<Object?> get props => [permits];
}

class PermitSubmittedState extends PermitState {
  final PermitEntity permit;

  PermitSubmittedState(this.permit);

  @override
  List<Object?> get props => [permit];
}

class PermitErrorState extends PermitState {
  final String message;

  PermitErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
