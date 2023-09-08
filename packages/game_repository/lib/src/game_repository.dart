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
  GameRepository({required Uri uri}) : _ws = WebSocket(uri);

  final WebSocket _ws;
  final GameService _gameService = GameService();

  /// function to get the current session data stream
  Stream<SessionState?> get session {
    return _ws.messages.cast<String>().map(
      (event) {
        final map = jsonDecode(event) as Map<String, dynamic>;
        if (map['eventType'] == null) {
          return null;
        }
        final response = WebSocketResponse.fromMap(map);
        if (response.eventType != EventType.invalid) {
          return SessionState.fromJson(response.data);
        }
        return null;
      },
    );
  }

  /// function to send the points to the server
  void sendPoints(DrawingPointsWrapper points) =>
      _ws.send(AddDrawingPointsEvent(data: points).encodedJson);

  /// Returns a uid
  Future<String?> getUID() async {
    try {
      final data = (await _gameService.connect()).data;
      return (jsonDecode(data.toString()) as Map<String, dynamic>)['data']
          .toString();
    } catch (e) {
      rethrow;
    }
  }

  /// function to add player to the server
  void addPlayer(Player player) =>
      _ws.send(AddPlayerEvent(data: player).encodedJson);

  /// function to send the chats to the server
  void sendChat(ChatModel chat) {
    _ws.send(AddToChatEvent(data: chat).encodedJson);
  }

  /// function to get the connection
  Stream<ConnectionState> get connection => _ws.connection;

  /// function to close the connection
  void close() => _ws.close();
}
