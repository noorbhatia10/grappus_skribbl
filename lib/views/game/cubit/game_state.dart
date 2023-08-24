// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'game_cubit.dart';

class GameState extends Equatable {
  const GameState({
    this.sessionState,
  });

  final SessionState? sessionState;

  GameState copyWith({
    SessionState? sessionState,
  }) {
    return GameState(
      sessionState: sessionState ?? this.sessionState,
    );
  }

  @override
  List<Object?> get props => [sessionState,];
}
