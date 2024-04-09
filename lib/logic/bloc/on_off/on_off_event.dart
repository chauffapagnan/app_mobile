part of 'on_off_bloc.dart';

abstract class OnOffEvent extends Equatable {
  const OnOffEvent();

  @override
  List<Object> get props => [];

}

class FetchOnOffEvent extends OnOffEvent {}

class OpenAppOnOffEvent extends OnOffEvent {}


class OnOffSwitchButtonClick extends OnOffEvent {
  final String id;
  final bool value;

  const OnOffSwitchButtonClick({required this.id, required this.value});

  @override
  List<Object> get props => [id, value];
}