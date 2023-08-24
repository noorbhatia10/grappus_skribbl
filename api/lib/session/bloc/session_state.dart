part of 'session_bloc.dart';

class SessionState extends Equatable {
  const SessionState({
    this.messages = const <ChatModel>[],
    this.currentPlayerId = '',
    this.players = const [],
    this.points = const DrawingPointsWrapper(points: null, paint: null),
  });

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        currentPlayerId: json['currentPlayerId'] as String,
        players: List<Player>.from(
          (json['players'] as List<dynamic>)
              .map((e) => Player.fromJson(e as String)),
        ),
        messages: List<ChatModel>.from(
          (json['messages'] as List<dynamic>)
              .map((e) => ChatModel.fromJson(e as Map<String,dynamic>)),
        ),
        points: DrawingPointsWrapper.fromJson(
          json['points'] as Map<String, dynamic>,
        ),
      );

  final String currentPlayerId;
  final List<Player> players;
  final List<ChatModel> messages;
  final DrawingPointsWrapper points;

  SessionState copyWith({
    String? currentPlayerId,
    List<Player>? players,
    List<ChatModel>? messages,
    DrawingPointsWrapper? points,
  }) {
    return SessionState(
      currentPlayerId: currentPlayerId ?? this.currentPlayerId,
      players: players ?? this.players,
      messages: messages ?? this.messages,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [points, currentPlayerId, players, messages];

  Map<String, dynamic> toJson() => {
        'players': List<dynamic>.from(players.map((x) => x)),
        'messages': List<dynamic>.from(messages.map((e) => e)),
        'currentPlayerId': currentPlayerId,
        'points': points.toJson(),
      };

  @override
  String toString() {
    return encodedJson();
  }

  String encodedJson() {
    return jsonEncode(toJson());
  }
}
