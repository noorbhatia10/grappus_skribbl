import 'dart:async';
import 'dart:convert';

import 'package:api/utils/random_words.dart';
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
    on<OnMessageSent>(_onMessageSent);
    on<OnTimerUpdate>(_onTimerUpdate);
  }

  void _onPlayerAdded(OnPlayerAdded event, Emitter<SessionState> emit) {
    if (state.players.length == 1 && state.correctAnswer.isEmpty) {
      emit(state.copyWith(correctAnswer: getRandomWord));
      print('correctAnswer: ${state.correctAnswer}');
    }
    emit(
      state.copyWith(
        currentPlayerId: event.player.userId,
        eventType: EventType.connect,
      ),
    );
    final players = <String, Player>{}
      ..addAll(state.players)
      ..putIfAbsent(event.player.userId, () => event.player);
    emit(
      state.copyWith(
        players: players,
        eventType: EventType.addPlayer,
        points: state.points,
      ),
    );
  }

  void _onAddPoints(OnPointsAdded event, Emitter<SessionState> emit) {
    emit(
      state.copyWith(points: event.points, eventType: EventType.drawing),
    );
  }

  void _onMessageSent(OnMessageSent event, Emitter<SessionState> emit) {
    final isCorrectAnswer = _checkIfMessageIsCorrectAnswer(event);
    if (isCorrectAnswer) {
      final players = state.players;
      players[event.chat.player.userId] = players[event.chat.player.userId]!
          .copyWith(hasAnsweredCorrectly: true);
      emit(
        state.copyWith(
          messages: [
            ...state.messages,
            event.chat.copyWith(
              player: event.chat.player.copyWith(hasAnsweredCorrectly: true),
            ),
          ],
          players: players,
          eventType: EventType.chat,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        messages: [...state.messages, event.chat],
        eventType: EventType.chat,
      ),
    );
  }

  bool _checkIfMessageIsCorrectAnswer(OnMessageSent event) {
    final message = event.chat.message.trim();
    return message.toUpperCase() == state.correctAnswer.toUpperCase();
  }

  void _onPlayerDisconnect(
    OnPlayerDisconnect event,
    Emitter<SessionState> emit,
  ) {
    final map = state.players;
    final players = map..removeWhere((key, value) => value == event.player);

    emit(state.copyWith(players: players));
  }

  @override
  Object toMessage(SessionState state) {
    return WebSocketResponse(
      data: state.toJson(),
      eventType: state.eventType,
    ).encodedJson();
  }

  void _onTimerUpdate(OnTimerUpdate event, Emitter<SessionState> emit) {
    emit(state.copyWith(timer: event.timer));
  }
}
