import 'dart:async';
import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_repository/game_repository.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required GameService gameService,
    required GameRepository gameRepository,
  })  : _gameService = gameService,
        _gameRepository = gameRepository,
        super(const InitialState()) {
    on<AddPlayer>(_onAddPlayer);
    on<ErrorEvent>(_onErrorEvent);
  }

  final GameService _gameService;
  final GameRepository _gameRepository;

  Future<void> _onAddPlayer(AddPlayer event, Emitter<LoginState> emit) async {
    try {
      final data = (await _gameService.connect(
        name: event.playerName,
        image: event.imagePath,
        color: event.color,
      )).data;

      final uid = (jsonDecode(data.toString()) as Map<String, dynamic>)['data']
          .toString();

      if (!uid.isNull) {
        final player = Player(
          userId: uid,
          name: event.playerName,
          imagePath: event.imagePath,
          userNameColor: event.color,
        );
        _gameRepository.addPlayer(player);
        emit(LoginSuccessFullState(playerUid: uid));
      } else {
        add(const ErrorEvent(error: 'Cannot get UID'));
      }
    } catch (e) {
      add(const ErrorEvent(error: 'Problem while adding player'));
    }
  }

  void _onErrorEvent(ErrorEvent event, Emitter<LoginState> emit) {
    emit(ErrorState(error: event.error));
  }
}
