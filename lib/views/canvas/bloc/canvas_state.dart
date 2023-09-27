part of 'canvas_bloc.dart';

class CanvasState extends Equatable {
  const CanvasState({
    this.drawingPointsWrapper =
        const DrawingPointsWrapper(points: null, paint: null),
  });

  final DrawingPointsWrapper drawingPointsWrapper;

  @override
  List<Object> get props => [drawingPointsWrapper];
}
