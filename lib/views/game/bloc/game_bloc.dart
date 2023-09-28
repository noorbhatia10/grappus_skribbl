import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_repository/game_repository.dart';
import 'package:models/models.dart';

part 'game_event.dart';

part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required GameRepository gameRepository})
      : _gameRepository = gameRepository,
        super(const GameState()) {
    on<ConnectGame>(_onConnectGame);
    on<OnMapData>(_onMapData);
    on<AddPlayer>(_onAddPlayer);
  }

  final GameRepository _gameRepository;
  StreamSubscription<WebSocketResponse?>? _roundStream;

  void _onConnectGame(ConnectGame event, Emitter<GameState> emit) {
    _roundStream = _gameRepository.webSocketStream.listen((response) {
      if (response != null) {
        if (response.eventType == EventType.roundStart ||
            response.eventType == EventType.roundEnd ||
            response.eventType == EventType.addPlayer ||
            response.eventType == EventType.gameEnd) {
          add(OnMapData(roundData: response.data));
        }
      }
    });
  }

  void _onMapData(OnMapData event, Emitter<GameState> emit) {
    emit(
      GameState.fromJson(event.roundData),
    );
  }

  void _onAddPlayer(AddPlayer event, Emitter<GameState> emit) {
    emit(state.copyWith(currentPlayerUid: event.playerUid));
  }
}
