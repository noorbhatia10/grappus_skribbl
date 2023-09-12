// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'game_cubit.dart';

class GameState extends Equatable {
  const GameState({
    this.sessionState,
    this.uid,
    this.messages,
  });

  final SessionState? sessionState;
  final String? uid;
  final List<ChatModel>? messages;

  GameState copyWith({
    SessionState? sessionState,
    String? uid,
    List<ChatModel>? messages,
  }) {
    return GameState(
      sessionState: sessionState ?? this.sessionState,
      uid: uid ?? this.uid,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [sessionState, uid, messages];
}

class GameErrorState extends GameState {
  final String message;

  const GameErrorState({
    required this.message,
  });
}
