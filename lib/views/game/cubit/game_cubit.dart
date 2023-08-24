import 'dart:async';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_repository/game_repository.dart';
import 'package:models/chat_model.dart';
import 'package:models/drawing_points.dart';
import 'package:models/player.dart';
import 'package:uuid/uuid.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({
    required GameRepository gameRepository,
  })  : _gameRepository = gameRepository,
        super(const GameState());

  final GameRepository _gameRepository;
  StreamSubscription<SessionState?>? _sessionStateSub;

  Future<void> connect(String name) async {
    _sessionStateSub = _gameRepository.session.listen((sessionState) {
      if (state.uid == null) {
        emit(state.copyWith(uid: sessionState?.currentPlayerId));
      }
      emit(state.copyWith(sessionState: sessionState));
    });
    await Future.delayed(const Duration(seconds: 1), () {
      final imagePath = Assets().getRandomImage();
      final player =
          Player(userId: const Uuid().v4(), name: name, imagePath: imagePath);
      addPlayer(player);
    });
  }

  Future<void> addPlayer(Player player) async {
    try {
      _gameRepository.addPlayer(player);
    } catch (e) {
      addError(e, StackTrace.current);
    }
  }

  Future<void> addPoints(DrawingPointsWrapper points) async =>
      _gameRepository.sendPoints(points);

  Future<void> addChats(ChatModel chat) async => _gameRepository.sendChat(chat);

  @override
  Future<void> close() async {
    await _sessionStateSub?.cancel();
    _gameRepository.close();
    return super.close();
  }
}
