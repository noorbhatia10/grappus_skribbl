import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends BroadcastBloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState(eventType: EventType.initial)) {
    on<AddMessage>(_onMessageAdded);
  }

  FutureOr<void> _onMessageAdded(AddMessage event, Emitter<ChatState> emit) {
    emit(ChatState(message: event.message, eventType: EventType.chat));
  }

  @override
  Object toMessage(ChatState state) {
    return WebSocketResponse(
      data: state.toJson(),
      eventType: state.eventType,
    ).toString();
  }
}
