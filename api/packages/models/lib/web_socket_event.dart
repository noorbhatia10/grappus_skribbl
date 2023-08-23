import 'dart:convert';

import 'package:models/chat_model.dart';
import 'package:models/drawing_points.dart';
import 'package:models/player.dart';

enum EventType {
  drawing('__drawing__'),
  chat('__chat__'),
  addPlayer('__add_player__'),
  invalid('__invalid__');

  final String name;

  const EventType(this.name);

  Map<String, dynamic> toJson() {
    return {'eventType': this.name};
  }
}

abstract class WebSocketEvent<T> {
  WebSocketEvent({
    required this.eventType,
    required this.data,
  });

  final EventType eventType;
  final T data;

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

class AddPlayerEvent extends WebSocketEvent<String> {
  AddPlayerEvent({
    required super.data,
    super.eventType = EventType.addPlayer,
  });

  @override
  Map<String, dynamic> toJson() {
    return {'eventType': eventType.name, 'data': data};
  }
}
