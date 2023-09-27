part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class ConnectChatStream extends ChatEvent {
  const ConnectChatStream();

  @override
  List<Object> get props => [];
}

class SendChatsToServer extends ChatEvent {
  const SendChatsToServer({required this.message});

  final ChatModel message;

  @override
  List<Object> get props => [message];
}

class SendChatsToLocal extends ChatEvent {
  const SendChatsToLocal({required this.message});

  final ChatModel message;

  @override
  List<Object> get props => [message];
}
