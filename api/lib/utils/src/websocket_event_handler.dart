import 'package:models/models.dart';

class WebSocketEventHandler {
  // ignore: strict_raw_type
  static WebSocketEvent? handleWebSocketEvent(
    Map<String, dynamic> jsonData,
  ) {
    final eventTypeName = jsonData['eventType'];
    final data = jsonData['data'] as Map<String, dynamic>;
    final eventType = EventType.values.firstWhere(
      (element) => element.name == eventTypeName,
      orElse: () => EventType.invalid,
    );
    if (eventType == EventType.invalid) {
      throw Exception('Invalid Event : $jsonData');
    }
    switch (eventType) {
      case EventType.drawing:
        return AddDrawingPointsEvent(data: DrawingPointsWrapper.fromJson(data));
      case EventType.chat:
        return AddToChatEvent(data: ChatModel.fromMap(data));

      case EventType.addPlayer:
      case EventType.invalid:
      case EventType.connect:
      case EventType.roundStart:
      case EventType.roundEnd:
      case EventType.gameEnd:
      case EventType.initial:
      case EventType.disconnect:
        return DisconnectPlayerEvent(
          data: data['uid'].toString(),
        );
    }
  }
}
