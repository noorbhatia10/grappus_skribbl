import 'dart:async';
import 'dart:convert';

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

  StreamSubscription<WebSocketResponse>? _response;

  Future<void> connect(String name, String imagePath, int userNameColor) async {
    _response = _gameRepository.response.listen((response) {
      emit(state.copyWith(eventType: response.eventType));
      switch (response.eventType) {
        case EventType.timerUpdate:
          emit(
            state.copyWith(
              remainingTime: response.data['remainingTime'] as int,
            ),
          );
        case EventType.drawing:
          emit(
            state.copyWith(
              drawingPoints: DrawingPointsWrapper.fromJson(
                response.data['points'] as Map<String, dynamic>,
              ),
            ),
          );
        case EventType.chat:
          final chatModel = ChatModel.fromMap(
            response.data['message'] as Map<String, dynamic>,
          );
          if (chatModel.playerUid == state.currentPlayerUid) return;
          emit(
            state.copyWith(
              chats: [
                ...?state.chats,
                chatModel,
              ],
            ),
          );
        case EventType.addPlayer:
          emit(
            state.copyWith(
              players: (response.data['players'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, Player.fromJson(e as String)),
              ),
            ),
          );
        case EventType.roundStart:
          emit(state.copyWith(
              round: response.data['round'] as int,
              currentDrawingPlayerId: response.data['isDrawing'] as String,
              hiddenAnswer: response.data['hiddenAnswer'] as String,
              correctAnswer: response.data['correctAnswer'] as String));
        case EventType.roundEnd:
          emit(
            state.copyWith(
              players: (response.data['players'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, Player.fromJson(e as String)),
              ),
              currentDrawingPlayerId: '',
            ),
          );
        case EventType.gameEnd:
          emit(
            state.copyWith(
              leaderboard: List<Player>.from(
                (response.data['leaderboard'] as List<dynamic>).map<Player>(
                  (x) => Player.fromMap(x as Map<String, dynamic>),
                ),
              ),
            ),
          );
        case EventType.connect:
        // TODO: Handle this case.
        case EventType.initial:
        // TODO: Handle this case.
        case EventType.disconnect:
        // TODO: Handle this case.
        case EventType.invalid:
        // TODO: Handle this case.
      }
    });
    // _sessionStateSub = _gameRepository.session.listen((sessionState) {
    //   emit(state.copyWith(sessionState: sessionState));
    //   if (state.sessionState?.eventType == EventType.chat) {
    //     final message = state.sessionState?.message;
    //     if (message != null && message.playerUid != state.uid) {
    //       addChatsToLocal(message);
    //     }
    //   }
    // });
    try {
      final uid = await _gameRepository.connect(
        name: name,
        image: imagePath,
        color: userNameColor,
      );

      if (uid == null) {
        throw Exception('Null UID');
      }
      emit(state.copyWith(currentPlayerUid: uid));

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

  void addChatsToLocal(ChatModel chatModel) =>
      emit(state.copyWith(chats: [...?state.chats, chatModel]));

  void endGame() => emit(const GameState());

  @override
  Future<void> close() async {
    _gameRepository.close(state.currentPlayerUid ?? '');

    // await _sessionStateSub?.cancel();
    await _response?.cancel();
    return super.close();
  }
}
