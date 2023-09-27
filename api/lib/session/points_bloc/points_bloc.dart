import 'dart:async';
import 'dart:convert';

import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'points_event.dart';

part 'points_state.dart';

class PointsBloc extends BroadcastBloc<PointsEvent, PointsState> {
  PointsBloc()
      : super(
          const PointsState(
            drawingPoints: DrawingPointsWrapper(points: null, paint: null),
            eventType: EventType.initial,
          ),
        ) {
    on<OnPointsAdded>(_onPointsAdded);
  }

  void _onPointsAdded(OnPointsAdded event, Emitter<PointsState> emit) {
    emit(
      PointsState(
        drawingPoints: event.points,
        eventType: EventType.drawing,
      ),
    );
  }

  @override
  Object toMessage(PointsState state) {
    return WebSocketResponse(
      data: state.toJson(),
      eventType: state.eventType,
    ).toString();
  }
}
