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
  // Stream<SessionState?> get session {
  //   return _ws.messages.cast<String>().map(
  //     (event) {
  //       final map = jsonDecode(event) as Map<String, dynamic>;
  //       final response = WebSocketResponse.fromMap(map);
  //       return SessionState.fromJson(response.data);
  //     },
  //   );
  // }

  Stream<WebSocketResponse> get response {
    return _ws.messages.cast<String>().map((event) {
      final map = jsonDecode(event) as Map<String, dynamic>;
      final response = WebSocketResponse.fromMap(map);
      return response;
    });
  }

  /// function to send the points to the server
  void sendPoints(DrawingPointsWrapper points) =>
      _ws.send(AddDrawingPointsEvent(data: points).encodedJson);

  /// Returns a uid
  Future<String?> connect({
    required String name,
    required String image,
    required int color,
  }) async {
    try {
      final data =
          (await _gameService.connect(name: name, image: image, color: color))
              .data;
      return (jsonDecode(data.toString()) as Map<String, dynamic>)['data']
          .toString();
    } catch (e) {
      rethrow;
    }
  }

  /// function to send the chats to the server
  void sendChat(ChatModel chat) {
    _ws.send(AddToChatEvent(data: chat).encodedJson);
  }

  /// function to get the connection
  Stream<ConnectionState> get connection => _ws.connection;

  /// function to close the connection
  void close(String uid) {
    _ws
      ..send(DisconnectPlayerEvent(data: uid).encodedJson)
      ..close();
  }
}
