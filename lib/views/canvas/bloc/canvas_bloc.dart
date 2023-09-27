import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_repository/game_repository.dart';
import 'package:models/models.dart';

part 'canvas_event.dart';

part 'canvas_state.dart';

class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  CanvasBloc({required GameRepository gameRepository})
      : _gameRepository = gameRepository,
        super(const CanvasState()) {
    on<ConnectPointsStream>(_onConnectPointStream);
    on<AddPointsToServer>(_onAddPointsToServer);
  }

  final GameRepository _gameRepository;
  StreamSubscription<DrawingPointsWrapper?>? _pointsStream;

  void _onAddPointsToServer(
      AddPointsToServer event, Emitter<CanvasState> emit) {
    _gameRepository.sendPoints(event.drawingPointsWrapper);
  }

  void _onConnectPointStream(
      ConnectPointsStream event, Emitter<CanvasState> emit) {
    _pointsStream = _gameRepository.pointsStream.listen((points) {
      if (points != null) {
        emit(CanvasState(drawingPointsWrapper: points));
      }
    });
  }
}
