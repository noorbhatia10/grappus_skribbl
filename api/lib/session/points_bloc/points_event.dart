part of 'points_bloc.dart';

abstract class PointsEvent extends Equatable {
  const PointsEvent();
}

class OnPointsAdded extends PointsEvent {
  const OnPointsAdded({required this.points});

  final DrawingPointsWrapper points;

  @override
  List<Object> get props => [points];
}
