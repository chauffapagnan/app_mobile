part of 'temp_bloc.dart';

abstract class TempEvent extends Equatable {
  const TempEvent();

  @override
  List<Object> get props => [];

}

class FetchTempEvent extends TempEvent {}

class OpenAppTempEvent extends TempEvent {}
class TempChangeValueEvent extends TempEvent {}


class TempButtonClick extends TempEvent {
  final String id;
  final double value;

  const TempButtonClick({required this.id, required this.value});

  @override
  List<Object> get props => [id, value];
}