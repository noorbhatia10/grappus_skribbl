import 'dart:convert';

import 'package:models/player.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatModel {
  final Player player;
  final String message;
  const ChatModel({
    required this.player,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'player': player.toMap(),
      'message': message,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> map) {
    return ChatModel(
      player: Player.fromMap(map['player'] as Map<String, dynamic>),
      message: map['message'] as String,
    );
  }


  @override
  String toString() {
    return jsonEncode(toJson());
  }

  @override
  List<Object> get props => [player, message];
}
