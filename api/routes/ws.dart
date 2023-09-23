import 'dart:convert';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:api/utils/utils.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:models/models.dart';

final Map<String, WebSocketChannel> webSocketChannels = {};

/// Websocket Handler
Future<Response> onRequest(RequestContext context) async {
  final roomId = context.request.uri.queryParameters['room_id'];
  final handler = webSocketHandler((channel, protocol) {
    final sessionBloc = context.read<SessionBloc>()..subscribe(channel);
    print('WebSocket connection opened with id: $roomId');
    // Store the WebSocket channel in the map
    webSocketChannels[roomId ?? 'common'] = channel;
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
          final websocketEvent =
              WebSocketEventHandler.handleWebSocketEvent(jsonData);
          if (websocketEvent == null) {
            return;
          }
          switch (websocketEvent.runtimeType) {
            case AddDrawingPointsEvent:
              final receivedPoints =
                  (websocketEvent as AddDrawingPointsEvent).data;
              sessionBloc.add(OnPointsAdded(receivedPoints));

            case AddToChatEvent:
              final chatModel = (websocketEvent as AddToChatEvent).data;
              sessionBloc.add(OnMessageSent(chatModel));

            case DisconnectPlayerEvent:
              final uid = (websocketEvent as DisconnectPlayerEvent).data;
              sessionBloc.add(OnPlayerDisconnect(uid));
          }
        } catch (e) {
          channel.sink.add(
            WebSocketResponse(
              data: {},
              status: 'error',
              eventType: EventType.invalid,
              message: e.toString(),
            ).encodedJson(),
          );
          rethrow;
        }
      },
      onDone: () {
        webSocketChannels.remove(roomId ?? 'common');
      },
    );
  });
  return handler(context);
}
