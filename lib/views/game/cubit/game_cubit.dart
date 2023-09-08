import 'dart:async';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_repository/game_repository.dart';
import 'package:models/models.dart';

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
      emit(state.copyWith(sessionState: sessionState));
    });

    final imagePath = Assets().getRandomImage();

    try {
      final uid = await _gameRepository.getUID();
      if (uid == null) {
        throw Exception('Null UID');
      }
      emit(state.copyWith(uid: uid));

      final player = Player(userId: uid, name: name, imagePath: imagePath);
      await addPlayer(player);
    } on Exception catch (e) {
      emit(GameErrorState(message: e.toString()));
      addError(e, StackTrace.current);
    }
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
