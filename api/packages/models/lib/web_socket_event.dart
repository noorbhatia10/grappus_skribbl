import 'dart:convert';

enum EventType { drawing, chat, invalid }

class WebSocketEvent<T> {
  WebSocketEvent({
    required this.eventType,
    required this.data,
  });

  final EventType eventType;
  final T data;

  Map<String, dynamic> toJson() {
    return {'eventType': eventType.name, 'data': data};
  }

  static WebSocketEvent<Map<String, dynamic>> fromJson(
    Map<String, dynamic> jsonData,
  ) {
    try {
      final eventTypeName = jsonData['eventType'];
      final data = jsonData['data'] as Map<String, dynamic>;
      final eventType = EventType.values.firstWhere(
        (element) => element.name == eventTypeName,
        orElse: () => EventType.invalid,
      );
      return WebSocketEvent<Map<String, dynamic>>(
          eventType: eventType, data: data);
    } catch (e) {
      print('$e');
      rethrow;
    }
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
//
// class AddDrawingPointsEvent extends WebSocketEvent<DrawingPointsWrapper> {
//   AddDrawingPointsEvent({
//     required super.data,
//     super.eventType = EventType.drawing,
//   });
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
//   @override
//   Map<String, dynamic> toJson() {
//     return {'eventType': eventType.name, 'data': data.toMap()};
//   }
// }
