// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'game_cubit.dart';

class GameState extends Equatable {
  const GameState({
    this.sessionState,
    this.uid,
  });

  final SessionState? sessionState;
  final String? uid;

  GameState copyWith({
    SessionState? sessionState,
    String? uid,
  }) {
    return GameState(
      sessionState: sessionState ?? this.sessionState,
      uid: uid ?? this.uid,
    );
  }

  @override
  List<Object?> get props => [sessionState, uid];
}

class GameErrorState extends GameState {
  final String message;
  const GameErrorState({
    required this.message,
  });
}
