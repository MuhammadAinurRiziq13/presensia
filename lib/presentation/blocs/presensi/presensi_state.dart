import 'package:equatable/equatable.dart';

abstract class PresensiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PresensiInitial extends PresensiState {}

class PresensiLoading extends PresensiState {}

class PresensiSuccess extends PresensiState {
  final String message;

  PresensiSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class PresensiFailure extends PresensiState {
  final String errorMessage;

  PresensiFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
