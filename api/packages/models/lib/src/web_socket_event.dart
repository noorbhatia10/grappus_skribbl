import 'dart:convert';

import 'package:models/src/chat_model.dart';
import 'package:models/src/drawing_points.dart';

enum EventType {
  connect(0),
  initial(1),
  drawing(2),
  chat(3),
  addPlayer(4),
  disconnect(5),
  timerUpdate(6),
  invalid(7),
  roundStart(8),
  roundEnd(9),
  gameEnd(10);

  const EventType(this.type);

  factory EventType.fromJson(Map<String, dynamic> json) => EventType.values
      .firstWhere((element) => element.type == json['eventType']);
  final int type;

  Map<String, dynamic> toJson() {
    return {'eventType': type};
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
