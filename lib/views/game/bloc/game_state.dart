part of 'game_bloc.dart';

class GameState extends Equatable {
  const GameState({
    this.currentPlayerUid = '',
    this.players = const [],
    this.currentDrawingPlayerUid = '',
    this.correctAnswer = '',
    this.hiddenAnswer = '',
    this.roundNumber = 1,
    this.remainingTime = 60,
    this.eventType = EventType.initial,
  });

  factory GameState.fromJson(Map<String, dynamic> data) {
    return GameState(
      players: List<Player>.from(
        (data['players'] as List<dynamic>).map<Player>(
              (x) => Player.fromJson(x as Map<String, dynamic>),
        ),
      ),
      currentDrawingPlayerUid: data['currentDrawingPlayerUid'] as String,
      correctAnswer: data['correctAnswer'] as String,
      hiddenAnswer: data['hiddenAnswer'] as String,
      roundNumber: data['roundNumber'] as int,
      remainingTime: data['remainingTime'] as int,
      eventType: EventType.fromJson(data['eventType'] as Map<String, dynamic>),
    );
  }

  final String currentPlayerUid;
  final List<Player> players;
  final String currentDrawingPlayerUid;
  final EventType eventType;
  final String correctAnswer;
  final String hiddenAnswer;
  final int roundNumber;
  final int remainingTime;

  @override
  List<Object> get props =>
      [
        currentPlayerUid,
        players,
        currentDrawingPlayerUid,
        eventType,
        correctAnswer,
        hiddenAnswer,
        roundNumber,
        remainingTime,
      ];

  GameState copyWith({
    String? currentPlayerUid,
    List<Player>? players,
    String? currentDrawingPlayerUid,
    EventType? eventType,
    String? correctAnswer,
    String? hiddenAnswer,
    int? roundNumber,
    int? remainingTime,
  }) {
    return GameState(
      currentPlayerUid: currentPlayerUid ?? this.currentPlayerUid,
      players: players ?? this.players,
      currentDrawingPlayerUid:
      currentDrawingPlayerUid ?? this.currentDrawingPlayerUid,
      eventType: eventType ?? this.eventType,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      hiddenAnswer: hiddenAnswer ?? this.hiddenAnswer,
      roundNumber: roundNumber ?? this.roundNumber,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}
