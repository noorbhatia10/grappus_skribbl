import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_repository/game_repository.dart';
import 'package:models/models.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required GameRepository gameRepository})
      : _gameRepository = gameRepository,
        super(const ChatState()) {
    on<ConnectChatStream>(_connectChatStream);
    on<SendChatsToLocal>(_onSendChatsToLocal);
    on<SendChatsToServer>(_onSendChatsToServer);
  }

  final GameRepository _gameRepository;
  StreamSubscription<ChatModel?>? _messageSubsciption;

  void _connectChatStream(ConnectChatStream event, Emitter<ChatState> emit) {
    _messageSubsciption = _gameRepository.messageStream.listen((message) {
      if (message != null) add(SendChatsToLocal(message: message));
    });
  }

  void _onSendChatsToLocal(SendChatsToLocal event, Emitter<ChatState> emit) {
    emit(ChatState(messages: [...?state.messages, event.message]));
    print('message: ${state.messages.toString()}');
  }

  void _onSendChatsToServer(SendChatsToServer event, Emitter<ChatState> emit) {
    _gameRepository.sendChat(event.message);
  }

  @override
  Future<void> close() async {
    await _messageSubsciption?.cancel();
    return super.close();
  }
}
