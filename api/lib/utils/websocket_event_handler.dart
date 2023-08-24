import 'package:models/chat_model.dart';
import 'package:models/drawing_points.dart';
import 'package:models/player.dart';
import 'package:models/web_socket_event.dart';

class WebSocketEventHandler {
  // ignore: strict_raw_type
  static WebSocketEvent handleWebSocketEvent(
    Map<String, dynamic> jsonData,
  ) {
    final eventTypeName = jsonData['eventType'];
    final data = jsonData['data'] as Map<String, dynamic>;
    final eventType = EventType.values.firstWhere(
      (element) => element.name == eventTypeName,
      orElse: () => EventType.invalid,
    );
    switch (eventType) {
      case EventType.drawing:
        return AddDrawingPointsEvent(data: DrawingPointsWrapper.fromJson(data));
      case EventType.chat:
        return AddToChatEvent(data: ChatModel.fromMap(data));

      case EventType.addPlayer:
        return AddPlayerEvent(
          data: Player.fromMap(data),
        );

      case EventType.invalid:
      case EventType.connect:
    }

    throw Exception('Invalid Event : $jsonData');
  }
}
