part of 'on_off_bloc.dart';

@immutable
abstract class OnOffState extends Equatable {
  const OnOffState();


  @override
  List<Object> get props => [];
}

final class OnOffInitialState extends OnOffState {}

class LoadingOnOffsState extends OnOffState {}

class OnOffsSuccesState extends OnOffState {
  final bool onOff;

  const OnOffsSuccesState({required this.onOff});

  @override
  List<Object> get props => [onOff];
}

class OnOffsErrorState extends OnOffState {
  final String message;

  const OnOffsErrorState({ required this.message});

  @override
  List<Object> get props => [message];
}
