part of 'round_bloc.dart';

class RoundState extends Equatable {
  const RoundState({
    this.players = const [],
    this.currentDrawingPlayerUid = '',
    this.correctAnswer = '',
    this.hiddenAnswer = '',
    this.roundNumber = 0,
    this.remainingTime = 60,
    this.eventType = EventType.initial,
  });

  factory RoundState.fromJson(Map<String, dynamic> data) {
    return RoundState(
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

  final List<Player> players;
  final String currentDrawingPlayerUid;
  final EventType eventType;
  final String correctAnswer;
  final String hiddenAnswer;
  final int roundNumber;
  final int remainingTime;


  Map<String, dynamic> toJson() {
    return {
      'players': players.map((player) => player.toJson()).toList(),
      'currentDrawingPlayerUid': currentDrawingPlayerUid,
      'correctAnswer': correctAnswer,
      'hiddenAnswer': hiddenAnswer,
      'roundNumber': roundNumber,
      'remainingTime': remainingTime,
      'eventType': eventType.toJson(),
    };
  }


  @override
  String toString() => jsonEncode(toJson());

  @override
  List<Object> get props =>
      [
        players,
        currentDrawingPlayerUid,
        eventType,
        correctAnswer,
        hiddenAnswer,
        roundNumber,
        remainingTime,
      ];

  RoundState copyWith({
    List<Player>? players,
    String? currentDrawingPlayerUid,
    EventType? eventType,
    String? correctAnswer,
    String? hiddenAnswer,
    int? roundNumber,
    int? remainingTime,
  }) {
    return RoundState(
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
