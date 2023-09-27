part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({
    required this.eventType, this.message,
  });

  factory ChatState.fromJson(Map<String, dynamic> data) {
    return ChatState(
      message: data['messages'] != null
          ? ChatModel.fromJson(data['message'] as Map<String, dynamic>)
          : null,
      eventType: EventType.fromJson(data['eventType'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': message?.toJson(),
      'eventType': eventType.toJson(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());

  final ChatModel? message;
  final EventType eventType;

  @override
  List<Object?> get props => [message, eventType];
}
