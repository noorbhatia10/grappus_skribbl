import 'dart:convert';

import 'package:api/session/chat_bloc/chat_bloc.dart';
import 'package:api/session/points_bloc/points_bloc.dart';
import 'package:api/session/round_bloc/round_bloc.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:models/models.dart';

/// Websocket Handler
Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {

    final chatBloc = context.read<ChatBloc>()..subscribe(channel);
    final pointsBloc = context.read<PointsBloc>()..subscribe(channel);
    final roundBloc = context.read<RoundBloc>()..subscribe(channel);

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

          // For Postman Testing
          /*
          if (data.toString() == 'chat checking') {
            final chat = ChatModel(
                playerUid: 'asfasdf',
                message: data.toString(),
                isCorrectWord: false);
            chatBloc.add(AddMessage(message: chat));
            return;
          }

          if(data.toString() == 'start'){
            roundBloc.add(const OnRoundStarted());
            return;
          }
          if(data.toString() == 'stop'){
            roundBloc.add(const OnGameEnded());
            return;
          }
          */

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

          if (websocketEvent.eventType == EventType.addPlayer) {
            final player = Player.fromJson(websocketEvent.data);
            print('adding player');
            roundBloc.add(AddPlayer(player: player));
            // channel.sink.add(roundBloc.state.toString());
          }

          if (websocketEvent.eventType == EventType.drawing) {
            final drawingPoints =
                DrawingPointsWrapper.fromJson(websocketEvent.data);
            pointsBloc.add(OnPointsAdded(points: drawingPoints));
            channel.sink.add(pointsBloc.state.toString());
          }

          if (websocketEvent.eventType == EventType.chat) {
            final chats = ChatModel.fromJson(websocketEvent.data);
            chatBloc.add(AddMessage(message: chats));
            channel.sink.add(chatBloc.state.toString());
          }
        } catch (e) {
          print('Error is: $e');
          channel.sink.add(
            WebSocketResponse(
              data: {},
              status: 'error',
              eventType: EventType.invalid,
              message: e.toString(),
            ).toString(),
          );
          rethrow;
        }
      },
      onDone: () {},
    );
  });
  return handler(context);
}
