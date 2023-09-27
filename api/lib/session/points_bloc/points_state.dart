part of 'points_bloc.dart';

class PointsState extends Equatable {
  const PointsState({
    required this.drawingPoints,
    required this.eventType,
  });

  factory PointsState.fromMap(Map<String, dynamic> data) {
    return PointsState(
      drawingPoints: DrawingPointsWrapper.fromJson(
        data['drawingPoints'] as Map<String, dynamic>,
      ),
      eventType: EventType.fromJson(data['eventType'] as Map<String, dynamic>),
    );
  }

  final DrawingPointsWrapper drawingPoints;
  final EventType eventType;

  @override
  List<Object> get props => [drawingPoints,eventType];

  Map<String, dynamic> toJson() {
    return {
      'drawingPoints': drawingPoints.toJson(),
      'eventType': eventType.toJson(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
