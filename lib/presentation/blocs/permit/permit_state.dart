import 'package:equatable/equatable.dart';
import '../../../data/models/permit_model.dart';

abstract class PermitState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PermitInitial extends PermitState {}

class PermitLoading extends PermitState {}

class PermitLoaded extends PermitState {
  final List<Permit> permits;

  PermitLoaded(this.permits);

  @override
  List<Object?> get props => [permits];
}

class PermitError extends PermitState {
  final String message;

  PermitError(this.message);

  @override
  List<Object?> get props => [message];
}
