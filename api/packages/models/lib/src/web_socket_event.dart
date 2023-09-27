import 'dart:convert';

import 'package:models/models.dart';
import 'package:models/src/chat_model.dart';
import 'package:models/src/drawing_points.dart';

enum EventType {
  connect('__connect__'),
  initial('__initial__'),
  drawing('__drawing__'),
  chat('__chat__'),
  addPlayer('__add_player__'),
  disconnect('__disconnect__'),
  timerUpdate('__timerUpdate__'),
  invalid('__invalid__'),
  roundStart('__round_start__'),
  roundEnd('__round_end__'),
  gameEnd('__game_end__');

  const EventType(this.name);

  factory EventType.fromJson(Map<String, dynamic> json) => EventType.values
      .firstWhere((element) => element.name == json['eventType']);
  final String name;

  Map<String, dynamic> toJson() {
    return {'eventType': name};
  }
}

class WebSocketEvent {
  WebSocketEvent({
    required this.eventType,
    required this.data,
  });

  factory WebSocketEvent.fromJson(
    Map<String, dynamic> jsonData,
  ) {
    try {
      final eventTypeName = jsonData['eventType'];
      final data = jsonData['data'] as Map<String, dynamic>;
      final eventType = EventType.values.firstWhere(
        (element) => element.name == eventTypeName,
        orElse: () => EventType.invalid,
      );
      return WebSocketEvent(
        eventType: eventType,
        data: data,
      );
    } catch (e) {
      print('$e');
      rethrow;
    }
  }

  final Map<String, dynamic> data;
  final EventType eventType;

  Map<String, dynamic> toJson() {
    return {'eventType': eventType.name, 'data': data};
  }

  @override
  String toString() => jsonEncode(toJson());
}

// class AddDrawingPointsEvent extends WebSocketEvent<DrawingPointsWrapper> {
//   AddDrawingPointsEvent({
//     required super.data,
//     super.eventType = EventType.drawing,
//   });
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {'eventType': eventType.name, 'data': data.toJson()};
//   }
// }
//
// class AddToChatEvent extends WebSocketEvent<ChatModel> {
//   AddToChatEvent({
//     required super.data,
//     super.eventType = EventType.chat,
//   });
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {'eventType': eventType.name, 'data': data.toJson()};
//   }
// }
//
// class AddPlayerEvent extends WebSocketEvent<Player> {
//   AddPlayerEvent({
//     required super.data,
//     super.eventType = EventType.addPlayer,
//   });
// }
//
// class DisconnectPlayerEvent extends WebSocketEvent<String> {
//   DisconnectPlayerEvent({
//     required super.data,
//     super.eventType = EventType.disconnect,
//   });
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'eventType': eventType.name,
//       'data': {'uid': data},
//     };
//   }
// }
