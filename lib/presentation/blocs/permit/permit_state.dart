import 'package:equatable/equatable.dart';
import 'package:presensia/domain/entities/permit.dart';

abstract class PermitState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PermitInitialState extends PermitState {}

class PermitLoadingState extends PermitState {}

class PermitSuccess extends PermitState {
  final List<PermitEntity> permits;

  PermitSuccess({required this.permits});

  @override
  List<Object?> get props => [permits];
}

class PermitSubmittedState extends PermitState {
  final PermitEntity permit;

  PermitSubmittedState(this.permit);

  @override
  List<Object?> get props => [permit];
}

class PermitFailure extends PermitState {
  final String message;

  PermitFailure(this.message);

  @override
  List<Object?> get props => [message];
}
