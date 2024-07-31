import 'package:equatable/equatable.dart';

abstract class GenericState<T> extends Equatable {
  const GenericState();

  @override
  List<Object?> get props => [];
}

class InitialState<T> extends GenericState<T> {}

class LoadingState<T> extends GenericState<T> {}

class SuccessState<T> extends GenericState<T> {
  final List<T> data;

  const SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ErrorState<T> extends GenericState<T> {
  final String message;

  const ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
