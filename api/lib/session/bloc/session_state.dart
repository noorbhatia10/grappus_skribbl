part of 'session_bloc.dart';

class SessionState extends Equatable {
  const SessionState({
    this.players = const {},
    this.points = const DrawingPointsWrapper(points: null, paint: null),
    this.eventType = EventType.initial,
    this.messages = const [],
    this.correctAnswer = '',
    this.remainingTime = roundDuration,
    this.numOfCorrectGuesses = 0,
    this.round = 1,
    this.isDrawing = '',
    this.hiddenAnswer = '',
    this.leaderboard = const [],
  });

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        isDrawing: json['isDrawing'] as String,
        numOfCorrectGuesses: json['numOfCorrectGuesses'] as int,
        remainingTime: json['secondsPassed'] as int,
        round: json['round'] as int,
        players: (json['players'] as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(k, Player.fromJson(e as String)),
            ) ??
            const {},
        hiddenAnswer: json['hiddenAnswer'].toString(),
        points: DrawingPointsWrapper.fromJson(
          json['points'] as Map<String, dynamic>,
        ),
        correctAnswer: json['correctAnswer'].toString(),
        eventType:
            EventType.fromJson(json['eventType'] as Map<String, dynamic>),
        messages: List<ChatModel>.from(
          (json['messages'] as List<dynamic>).map<ChatModel>(
            (x) => ChatModel.fromMap(x as Map<String, dynamic>),
          ),
        ),
        leaderboard: List<Player>.from(
          (json['leaderboard'] as List<dynamic>).map<Player>(
            (x) => Player.fromMap(x as Map<String, dynamic>),
          ),
        ),
      );
  static const roundDuration = 60;

  final Map<String, Player> players;
  final DrawingPointsWrapper points;
  final EventType eventType;
  final List<ChatModel> messages;
  final String correctAnswer;
  final int remainingTime;
  final int numOfCorrectGuesses;
  final String hiddenAnswer;
  final int round;
  final String isDrawing;
  final List<Player> leaderboard;

  SessionState copyWith({
    Map<String, Player>? players,
    DrawingPointsWrapper? points,
    EventType? eventType,
    List<ChatModel>? messages,
    String? correctAnswer,
    int? remainingTime,
    int? numOfCorrectGuesses,
    String? hiddenAnswer,
    int? round,
    String? isDrawing,
    List<Player>? leaderboard,
  }) {
    return SessionState(
      players: players ?? this.players,
      points: points ?? this.points,
      eventType: eventType ?? this.eventType,
      messages: messages ?? this.messages,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      remainingTime: remainingTime ?? this.remainingTime,
      numOfCorrectGuesses: numOfCorrectGuesses ?? this.numOfCorrectGuesses,
      hiddenAnswer: hiddenAnswer ?? this.hiddenAnswer,
      round: round ?? this.round,
      isDrawing: isDrawing ?? this.isDrawing,
      leaderboard: leaderboard ?? this.leaderboard,
    );
  }

  @override
  List<Object?> get props {
    return [
      players,
      points,
      eventType,
      messages,
      correctAnswer,
      remainingTime,
      numOfCorrectGuesses,
      hiddenAnswer,
      round,
      leaderboard,
      isDrawing,
    ];
  }

  Map<String, dynamic> toJson() => {
        'players': Map<String, Player>.from(players),
        'points': points.toJson(),
        'eventType': eventType.toJson(),
        'messages': messages.map((x) => x.toMap()).toList(),
        'correctAnswer': correctAnswer,
        'secondsPassed': remainingTime,
        'numOfCorrectGuesses': numOfCorrectGuesses,
        'round': round,
        'isDrawing': isDrawing,
        'hiddenAnswer': hiddenAnswer,
        'leaderboard': leaderboard.map((players) => players.toMap()).toList(),
      };

  @override
  String toString() {
    return encodedJson();
  }

  String encodedJson() {
    return jsonEncode(toJson());
  }
}
