part of 'session_bloc.dart';

class SessionState extends Equatable {
  const SessionState({
    this.currentPlayerId,
    this.players = const {},
    this.points = const DrawingPointsWrapper(points: null, paint: null),
    this.eventType = EventType.invalid,
    this.messages = const [],
    this.correctAnswer = '',
    this.timer = -1,
  });

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        currentPlayerId: json['currentPlayerId'] as String,
        players: (json['players'] as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(k, Player.fromJson(e as String)),
            ) ??
            const {},
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
        timer: json['timer'] as int,
      );

  final String? currentPlayerId;
  final Map<String, Player> players;
  final DrawingPointsWrapper points;
  final EventType eventType;
  final List<ChatModel> messages;
  final String correctAnswer;
  final int timer;

  SessionState copyWith({
    String? currentPlayerId,
    Map<String, Player>? players,
    DrawingPointsWrapper? points,
    EventType? eventType,
    List<ChatModel>? messages,
    String? correctAnswer,
    int? timer,
  }) {
    return SessionState(
      currentPlayerId: currentPlayerId ?? this.currentPlayerId,
      players: players ?? this.players,
      points: points ?? this.points,
      eventType: eventType ?? this.eventType,
      messages: messages ?? this.messages,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      timer: timer ?? this.timer,
    );
  }

  @override
  List<Object?> get props => [
        points,
        currentPlayerId,
        players,
        eventType,
        messages,
        correctAnswer,
        timer,
      ];

  Map<String, dynamic> toJson() => {
        'players': Map<String, Player>.from(players),
        'currentPlayerId': currentPlayerId,
        'points': points.toJson(),
        'eventType': eventType.toJson(),
        'messages': messages.map((x) => x.toMap()).toList(),
        'correctAnswer': correctAnswer,
        'timer': timer,
      };

  @override
  String toString() {
    return encodedJson();
  }

  String encodedJson() {
    return jsonEncode(toJson());
  }
}
