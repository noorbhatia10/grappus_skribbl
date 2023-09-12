import 'dart:convert';

import 'package:models/src/chat_model.dart';
import 'package:models/src/drawing_points.dart';
import 'package:models/src/player.dart';

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

abstract class WebSocketEvent<T> {
  WebSocketEvent({
    required this.eventType,
    required this.data,
  });

  final T data;
  final EventType eventType;

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  String get encodedJson => jsonEncode(toJson());
}

class AddDrawingPointsEvent extends WebSocketEvent<DrawingPointsWrapper> {
  AddDrawingPointsEvent({
    required super.data,
    super.eventType = EventType.drawing,
  });

  @override
  Map<String, dynamic> toJson() {
    return {'eventType': eventType.name, 'data': data.toJson()};
  }
}

class AddToChatEvent extends WebSocketEvent<ChatModel> {
  AddToChatEvent({
    required super.data,
    super.eventType = EventType.chat,
  });

  @override
  Map<String, dynamic> toJson() {
    return {'eventType': eventType.name, 'data': data.toMap()};
  }
}

class DisconnectPlayerEvent extends WebSocketEvent<String> {
  DisconnectPlayerEvent({
    required super.data,
    super.eventType = EventType.disconnect,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'eventType': eventType.name,
      'data': {'uid': data},
    };
  }
}
