import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:api/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'round_event.dart';

part 'round_state.dart';

class RoundBloc extends BroadcastBloc<RoundEvent, RoundState> {
  RoundBloc({
    required Ticker ticker,
  })  : _ticker = ticker,
        super(const RoundState()) {
    on<AddPlayer>(_onPlayerAdded);
    on<PlayerDisconnected>(_onPlayerDisconnected);
    on<OnRoundStarted>(_onRoundStarted);
    on<OnRoundEnded>(_onRoundEnded);
    on<OnGameEnded>(_onGameEnded);
    on<OnTimerStart>(_onTimerStart);
    on<OnTimerUpdate>(_onTimerUpdate);
    on<OnTimerCancel>(_onTimerCancel);
  }

  final Ticker _ticker;
  StreamSubscription<int>? tickerSub;

  void _onPlayerAdded(AddPlayer event, Emitter<RoundState> emit) {
    // final roundModel = state.roundModel.copyWith(
    //   players: [...state.roundModel.players, event.player],
    //   eventType: EventType.addPlayer,
    // );
    // final players = state.players
    print('playerList before: ${state.players}');
    emit(
      state.copyWith(
        players: [...state.players, event.player],
        eventType: EventType.addPlayer,
      ),
    );
    print('playerList after: ${state.players}');

  }

  void _onPlayerDisconnected(
      PlayerDisconnected event, Emitter<RoundState> emit) {
    emit(
      state.copyWith(
        players: state.players
          ..removeWhere(
            (player) => player.userId == event.playerUid,
          ),
        eventType: EventType.disconnect,
      ),
    );
  }

  Future<void> _onRoundStarted(
    OnRoundStarted event,
    Emitter<RoundState> emit,
  ) async {
    add(const OnTimerCancel());

    final players = state.players;

    if (players.length < 2) return;

    final remainingPlayers =
        players.where((player) => !player.hasCompletedDrawingRound).toList();

    final randomIndex = Random().nextInt(remainingPlayers.length);
    final randomWord = await getRandomWord;
    final currentDrawingPlayerUid = remainingPlayers[randomIndex].userId;

    final indexOfDrawingPlayer = players
        .indexWhere((player) => player.userId == currentDrawingPlayerUid);

    players[indexOfDrawingPlayer] =
        players[indexOfDrawingPlayer].copyWith(isDrawing: true);

    emit(
      state.copyWith(
        eventType: EventType.roundStart,
        players: players,
        roundNumber: state.roundNumber + 1,
        currentDrawingPlayerUid: currentDrawingPlayerUid,
        hiddenAnswer: randomWord
            .split('')
            .map(
              (char) => char == ' ' ? ' ' : '*',
            )
            .join(),
        correctAnswer: randomWord,
      ),
    );

    add(const OnTimerStart());
  }

  Future<void> _onRoundEnded(
      OnRoundEnded event, Emitter<RoundState> emit) async {
    add(const OnTimerCancel());

    final players = state.players.map((player) {
      player = player.copyWith(
        isDrawing: false,
        hasAnsweredCorrectly: false,
        numOfGuesses: 0,
        guessedAt: -1,
        score: player.score + 100,
      );
      if (player.isDrawing) {
        player = player.copyWith(hasCompletedDrawingRound: true);
        print('updated player $player');
      }
      return player;
    }).toList();

    print('new list: $players');
    emit(
      state.copyWith(
        eventType: EventType.roundEnd,
        players: players,
        currentDrawingPlayerUid: '',
      ),
    );

    final remainingPlayers =
        players.where((player) => !player.hasCompletedDrawingRound).toList();

    print('remaining player: $remainingPlayers');
    if (remainingPlayers.isEmpty) {
      add(const OnGameEnded());
      return;
    }
    await Future.delayed(
      const Duration(seconds: 5),
      () => add(const OnRoundStarted()),
    );
  }

  void _onGameEnded(OnGameEnded event, Emitter<RoundState> emit) {
    add(const OnTimerCancel());
    final leaderboard = state.players
      ..sort((a, b) => b.score.compareTo(a.score));

    emit(
      state.copyWith(
        eventType: EventType.gameEnd,
        players: leaderboard,
        correctAnswer: '',
        hiddenAnswer: '',
      ),
    );
  }

  void _onTimerStart(OnTimerStart event, Emitter<RoundState> emit) {
    tickerSub = _ticker.tick(ticks: 10).listen(
          (duration) => add(OnTimerUpdate(duration: duration)),
        );
  }

  void _onTimerUpdate(OnTimerUpdate event, Emitter<RoundState> emit) {
    emit(
      state.copyWith(
        remainingTime: event.duration,
      ),
    );
    /*
    /// Dont show the answer for first 10 seconds
    if (event.duration < 51) {
      final difference = (event.duration.toDouble()) / 10;

      /// If the timer hits 50,40,30,20 s time mark
      if ((difference is int || difference.toInt() == difference) &&
          difference <= 5 &&
          difference > 1) {
        var hiddenAnswer = state.hiddenAnswer;

        /// choose a random char to show from [correctAnswer]
        final charIndex = Random().nextInt(state.correctAnswer.length - 1);

        hiddenAnswer = replaceCharAt(
          state.hiddenAnswer,
          charIndex,
          state.correctAnswer[charIndex],
        );

        emit(
          state.copyWith(
            hiddenAnswer: hiddenAnswer,
            eventType: EventType.timerUpdate,
          ),
        );
      }
    }
    */

    if (event.duration <= 0) {
      add(const OnRoundEnded());
      return;
    }
  }

  Future<void> _onTimerCancel(
      OnTimerCancel event, Emitter<RoundState> emit) async {
    await tickerSub?.cancel();
  }

  @override
  Object toMessage(RoundState state) {
    return WebSocketResponse(
      data: state.toJson(),
      eventType: state.eventType,
    ).toString();
  }
}
