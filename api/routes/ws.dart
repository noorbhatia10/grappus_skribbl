import 'dart:convert';
import 'package:api/session/bloc/session_bloc.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:models/chat_model.dart';
import 'package:models/drawing_points.dart';
import 'package:models/player.dart';
import 'package:models/web_socket_event.dart';

import 'package:uuid/uuid.dart';

/// Websocket Handler
Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final uid = const Uuid().v4();
    final player = Player(
      userId: uid,
      name: 'name',
    );
    final sessionBloc = context.read<SessionBloc>()
      ..subscribe(channel)
      ..add(OnPlayerAdded(player));

    channel.sink.add(
      sessionBloc.state.toString(),
    );

    channel.stream.listen(
      (data) {
        try {
          if (data == null || data.toString().isEmpty) {
            channel.sink.add(
              jsonEncode({
                'status': 'Error invalid data:$data',
              }),
            );

            return;
          }
          final jsonData = jsonDecode(data.toString());
          if (jsonData is! Map<String, dynamic>) {
            channel.sink.add(
              jsonEncode({
                'status': 'Error invalid data:$data',
              }),
            );
            return;
          }

          final websocketEvent = WebSocketEvent.fromJson(jsonData);

          if (websocketEvent.eventType == EventType.drawing) {
            final receivedPoints =
                DrawingPointsWrapper.fromJson(websocketEvent.data);
            sessionBloc.add(OnPointsAdded(receivedPoints));
          }
          if (websocketEvent.eventType == EventType.chat) {
            final chatModel = ChatModel.fromJson(websocketEvent.data);
            sessionBloc.add(OnChatAdded(chatModel));
          }
        } catch (e) {
          channel.sink.add(
            jsonEncode({'status': 'error', 'message': e.toString()}),
          );
        }
      },
      onDone: () {
        final currentUserId = sessionBloc.state.currentPlayerId;
        sessionBloc
          ..add(OnPlayerDisconnect(currentUserId))
          ..unsubscribe(channel);
      },
    );
  });
  return handler(context);
}
