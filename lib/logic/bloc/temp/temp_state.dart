part of 'temp_bloc.dart';

@immutable
abstract class TempState extends Equatable {
  const TempState();


  @override
  List<Object> get props => [];
}

final class TempInitialState extends TempState {}

class LoadingTempsState extends TempState {}
class TempsChangeValueState extends TempState {
  final String dateNow;

  const TempsChangeValueState({required this.dateNow});

  @override
  List<Object> get props => [dateNow];
}

class TempsSuccesState extends TempState {
  final double temp;

  const TempsSuccesState({required this.temp});

  @override
  List<Object> get props => [temp];
}

class TempsErrorState extends TempState {
  final String message;

  const TempsErrorState({ required this.message});

  @override
  List<Object> get props => [message];
}
