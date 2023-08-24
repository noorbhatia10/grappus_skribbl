import 'dart:convert';

import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/chat_model.dart';
import 'package:models/drawing_points.dart';
import 'package:models/player.dart';
import 'package:models/web_socket_event.dart';
import 'package:models/web_socket_response.dart';

part 'session_event.dart';

part 'session_state.dart';

class SessionBloc extends BroadcastBloc<SessionEvent, SessionState> {
  SessionBloc() : super(const SessionState()) {
    on<OnPlayerAdded>(_onPlayerAdded);
    on<OnPointsAdded>(_onAddPoints);
    on<OnPlayerDisconnect>(_onPlayerDisconnect);
    on<OnChatAdded>(_onChatAdded);
  }

  void _onPlayerAdded(OnPlayerAdded event, Emitter<SessionState> emit) {
    final players = <Player>[...state.players, event.player];
    emit(
      state.copyWith(
        players: players,
        currentPlayerId: event.player.userId,
        points: state.points,
      ),
    );
  }

  @override
  Object toMessage(SessionState state) {
    return WebSocketResponse(
      data: state.toJson(),
      eventType: EventType.drawing,
    ).encodedJson();
  }

  void _onAddPoints(OnPointsAdded event, Emitter<SessionState> emit) {
    emit(
      state.copyWith(points: event.points),
    );
  }

  void _onPlayerDisconnect(
    OnPlayerDisconnect event,
    Emitter<SessionState> emit,
  ) {
    final players = [
      ...state.players,
    ]..removeWhere((player) => player.userId == event.userId);

    emit(
      state.copyWith(players: players),
    );
  }

  void _onChatAdded(OnChatAdded event, Emitter<SessionState> emit) {
    emit(state.copyWith(messages: [...state.messages, event.chatModel]));
  }
}
