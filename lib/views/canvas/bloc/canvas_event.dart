part of 'canvas_bloc.dart';

abstract class CanvasEvent extends Equatable {
  const CanvasEvent();
}

class ConnectPointsStream extends CanvasEvent {
  const ConnectPointsStream();

  @override
  List<Object> get props => [];
}

class AddPointsToServer extends CanvasEvent {
  const AddPointsToServer({required this.drawingPointsWrapper});

  final DrawingPointsWrapper drawingPointsWrapper;

  @override
  List<Object> get props => [drawingPointsWrapper];
}
