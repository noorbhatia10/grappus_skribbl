import 'dart:convert';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:models/chat_model.dart';
import 'package:models/drawing_points.dart';
import 'package:models/web_socket_event.dart';
import 'package:models/web_socket_response.dart';
import 'package:web_socket_client/web_socket_client.dart';

/// {@template game_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class GameRepository {
  /// {@macro game_repository}
  GameRepository({required Uri uri}) : _ws = WebSocket(uri);

  final WebSocket _ws;

  /// function to get the current session data stream
  Stream<SessionState?> get session {
    return _ws.messages.cast<String>().map(
      (event) {
        final map = jsonDecode(event) as Map<String, dynamic>;
        if (map['eventType'] == null) {
          return null;
        }
        final response = WebSocketResponse.fromMap(map);
        if (response.eventType == EventType.drawing) {
          return SessionState.fromJson(response.data);
        }
        return null;
      },
    );
  }

  /// function to send the points to the server
  void sendPoints(DrawingPointsWrapper points) => _ws.send(
        WebSocketEvent<DrawingPointsWrapper>(
          eventType: EventType.drawing,
          data: points,
        ).toString(),
      );

  ///
  void sendChat(ChatModel chat) {
    _ws.send(
      WebSocketEvent<ChatModel>(eventType: EventType.chat, data: chat)
          .toString(),
    );
  }

  /// function to get the connection
  Stream<ConnectionState> get connection => _ws.connection;

  /// function to close the connection
  void close() => _ws.close();
}
