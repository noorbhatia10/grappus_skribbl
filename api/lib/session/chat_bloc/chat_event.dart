part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class AddMessage extends ChatEvent {
  const AddMessage({required this.message});

  final ChatModel message;

  @override
  List<Object> get props => [message];
}
