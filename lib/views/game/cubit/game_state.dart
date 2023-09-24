// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'game_cubit.dart';

class GameState extends Equatable {
  const GameState(
      {this.players,
      this.drawingPoints,
      this.correctAnswer,
      this.remainingTime,
      this.numOfCorrectGuesses,
      this.hiddenAnswer,
      this.round,
      this.currentDrawingPlayerId,
      this.leaderboard,
      this.currentPlayerUid,
      this.chats,
      this.eventType});

  final String? currentPlayerUid;
  final List<ChatModel>? chats;
  final Map<String, Player>? players;
  final DrawingPointsWrapper? drawingPoints;
  final String? correctAnswer;
  final int? remainingTime;
  final int? numOfCorrectGuesses;
  final String? hiddenAnswer;
  final int? round;
  final String? currentDrawingPlayerId;
  final List<Player>? leaderboard;
  final EventType? eventType;

  @override
  List<Object?> get props => [
        currentPlayerUid,
        chats,
        players,
        drawingPoints,
        correctAnswer,
        remainingTime,
        numOfCorrectGuesses,
        hiddenAnswer,
        round,
        currentDrawingPlayerId,
        leaderboard,
        eventType,
      ];

  GameState copyWith({
    String? currentPlayerUid,
    List<ChatModel>? chats,
    Map<String, Player>? players,
    DrawingPointsWrapper? drawingPoints,
    String? correctAnswer,
    int? remainingTime,
    int? numOfCorrectGuesses,
    String? hiddenAnswer,
    int? round,
    String? currentDrawingPlayerId,
    List<Player>? leaderboard,
    EventType? eventType,
  }) {
    return GameState(
      currentPlayerUid: currentPlayerUid ?? this.currentPlayerUid,
      chats: chats ?? this.chats,
      players: players ?? this.players,
      drawingPoints: drawingPoints ?? this.drawingPoints,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      remainingTime: remainingTime ?? this.remainingTime,
      numOfCorrectGuesses: numOfCorrectGuesses ?? this.numOfCorrectGuesses,
      hiddenAnswer: hiddenAnswer ?? this.hiddenAnswer,
      round: round ?? this.round,
      currentDrawingPlayerId:
          currentDrawingPlayerId ?? this.currentDrawingPlayerId,
      leaderboard: leaderboard ?? this.leaderboard,
      eventType: eventType ?? this.eventType,
    );
  }
}

class GameErrorState extends GameState {
  final String message;

  const GameErrorState({
    required this.message,
  });
}
