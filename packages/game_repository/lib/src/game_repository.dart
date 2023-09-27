import 'dart:convert';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:web_socket_client/web_socket_client.dart';

/// {@template game_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class GameRepository {
  /// {@macro game_repository}
  GameRepository();

  final WebSocket _ws = WebSocket(Uri.parse(Endpoints.baseUrl));

  /// function to get the current session data stream

  Stream<ChatModel?> get messageStream {
    return _ws.messages.cast<String>().map((event) {
      final map = jsonDecode(event) as Map<String, dynamic>;
      if (map['eventType'] == null || map['data'] == null) {
        return null;
      }
      final response = WebSocketResponse.fromJson(map);
      if (response.eventType == EventType.chat) {
        print('incoming chat data: ${ChatModel.fromJson(
          response.data['messages'] as Map<String, dynamic>,
        )}');
        return ChatModel.fromJson(
          response.data['messages'] as Map<String, dynamic>,
        );
      }
    });
  }

  Stream<DrawingPointsWrapper?> get pointsStream {
    return _ws.messages.cast<String>().map((event) {
      final map = jsonDecode(event) as Map<String, dynamic>;
      if (map['eventType'] == null || map['data'] == null) {
        return null;
      }
      final response = WebSocketResponse.fromJson(map);
      if (response.eventType == EventType.drawing) {
        return DrawingPointsWrapper.fromJson(
          response.data['drawingPoints'] as Map<String, dynamic>,
        );
      }
    });
  }

  Stream<Map<String, dynamic>?> get roundStream {
    return _ws.messages.cast<String>().map((event) {
      final map = jsonDecode(event) as Map<String, dynamic>;
      if (map['eventType'] == null || map['data'] == null) {
        return null;
      }
      final response = WebSocketResponse.fromJson(map);
      if (response.eventType == EventType.addPlayer ||
          response.eventType == EventType.roundStart ||
          response.eventType == EventType.roundEnd ||
          response.eventType == EventType.gameEnd) {
        print('incoming data: ${RoundModel.fromJson(
          response.data['roundData'] as Map<String, dynamic>,
        )}');
        return response.data['roundData'] as Map<String, dynamic>;
      }
    });
  }

  void sendPoints(DrawingPointsWrapper points) => _ws.send(
        WebSocketEvent(
          eventType: EventType.drawing,
          data: points.toJson(),
        ).toString(),
      );

  void addPlayer(Player player) {
    print(
        'data is sent from client: ${WebSocketEvent(eventType: EventType.addPlayer, data: player.toJson())}');
    try {
      _ws.send(
        WebSocketEvent(eventType: EventType.addPlayer, data: player.toJson())
            .toString(),
      );
    } catch (e) {
      print('error is: $e');
    }
  }

  void sendChat(ChatModel chat) {
    _ws.send(
      WebSocketEvent(eventType: EventType.chat, data: chat.toJson()).toString(),
    );
  }

  /// function to get the connection
  Stream<ConnectionState> get connection => _ws.connection;

  /// function to close the connection
  void close(String uid) {
    _ws.close();
  }
}
