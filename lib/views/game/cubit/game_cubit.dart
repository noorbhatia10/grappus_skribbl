import 'dart:async';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_repository/game_repository.dart';
import 'package:models/models.dart';
import 'dart:html' as html;

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({
    required GameRepository gameRepository,
  })  : _gameRepository = gameRepository,
        super(const GameState());

  final GameRepository _gameRepository;
  StreamSubscription<SessionState?>? _sessionStateSub;

  Future<void> connect(String name, String imagePath, int userNameColor) async {
    _sessionStateSub = _gameRepository.session.listen((sessionState) {
      emit(state.copyWith(sessionState: sessionState));
    });

    try {
      final uid = await _gameRepository.connect(
        name: name,
        image: imagePath,
        color: userNameColor,
      );

      if (uid == null) {
        throw Exception('Null UID');
      }
      emit(state.copyWith(uid: uid));

      html.window.onBeforeUnload.listen((event) async {
        await close();
      });
    } on Exception catch (e) {
      emit(GameErrorState(message: e.toString()));
      addError(e, StackTrace.current);
    }
  }

  Future<void> addPoints(DrawingPointsWrapper points) async =>
      _gameRepository.sendPoints(points);

  Future<void> addChats(ChatModel chat) async => _gameRepository.sendChat(chat);

  void endGame() => emit(const GameState());

  @override
  Future<void> close() async {
    _gameRepository.close(state.uid ?? '');

    await _sessionStateSub?.cancel();
    return super.close();
  }
}
