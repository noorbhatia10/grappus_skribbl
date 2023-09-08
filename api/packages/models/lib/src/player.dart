// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Player {
  String userId;
  String name;
  String imagePath;
  final bool hasAnsweredCorrectly;
  final int score;
  final bool isDrawing;
  final int numOfGuesses;
  final int guessedAt;
  final bool hasCompletedDrawingRound;
  final int userNameColor;
  Player({
    required this.userId,
    required this.name,
    required this.imagePath,
    required this.userNameColor,
    this.hasCompletedDrawingRound = false,
    this.hasAnsweredCorrectly = false,
    this.score = 0,
    this.isDrawing = false,
    this.numOfGuesses = 0,
    this.guessedAt = -1,
  });

  Player copyWith({
    String? userId,
    String? name,
    String? imagePath,
    bool? hasAnsweredCorrectly,
    int? score,
    bool? isDrawing,
    int? numOfGuesses,
    int? guessedAt,
    bool? hasCompletedDrawingRound,
    int? userNameColor,
  }) {
    return Player(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      hasAnsweredCorrectly: hasAnsweredCorrectly ?? this.hasAnsweredCorrectly,
      score: score ?? this.score,
      isDrawing: isDrawing ?? this.isDrawing,
      numOfGuesses: numOfGuesses ?? this.numOfGuesses,
      guessedAt: guessedAt ?? this.guessedAt,
      hasCompletedDrawingRound:
          hasCompletedDrawingRound ?? this.hasCompletedDrawingRound,
      userNameColor: userNameColor ?? this.userNameColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'imagePath': imagePath,
      'hasAnsweredCorrectly': hasAnsweredCorrectly,
      'score': score,
      'isDrawing': isDrawing,
      'numOfGuesses': numOfGuesses,
      'guessedAt': guessedAt,
      'hasCompletedDrawingRound': hasCompletedDrawingRound,
      'userNameColor': userNameColor,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      userId: map['userId'] as String,
      name: map['name'] as String,
      imagePath: map['imagePath'] as String,
      hasAnsweredCorrectly: map['hasAnsweredCorrectly'] as bool,
      score: map['score'] as int,
      isDrawing: map['isDrawing'] as bool,
      numOfGuesses: map['numOfGuesses'] as int,
      guessedAt: map['guessedAt'] as int,
      hasCompletedDrawingRound: map['hasCompletedDrawingRound'] as bool,
      userNameColor: map['userNameColor'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) =>
      Player.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
