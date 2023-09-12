// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  const ChatModel({
    required this.playerUid,
    required this.message,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      playerUid: map['playerUid'] as String,
      message: map['message'] as String,
    );
  }

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
  final String playerUid;
  final String message;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'playerUid': playerUid,
      'message': message,
    };
  }

  String toJson() => json.encode(toMap());

  ChatModel copyWith({
    String? playerUid,
    String? message,
  }) {
    return ChatModel(
      playerUid: playerUid ?? this.playerUid,
      message: message ?? this.message,
    );
  }
}
