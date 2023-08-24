import 'dart:async';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_repository/game_repository.dart';
import 'package:models/chat_model.dart';
import 'package:models/drawing_points.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({
    required GameRepository gameRepository,
  })  : _gameRepository = gameRepository,
        super(const GameState());

  final GameRepository _gameRepository;
  StreamSubscription<SessionState?>? _sessionStateSub;

  Future<void> connect() async {
    _sessionStateSub = _gameRepository.session.listen((sessionState) {
      emit(state.copyWith(sessionState: sessionState));
    });
  }

  Future<void> addPoints(DrawingPointsWrapper points) async {
    _gameRepository.sendPoints(points);
  }

  Future<void> addChats(ChatModel chat) async {
    _gameRepository.sendChat(chat);
  }

  @override
  Future<void> close() async {
    await _sessionStateSub?.cancel();
    _gameRepository.close();
    return super.close();
  }
}
