part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();
}

class OnPlayerAdded extends SessionEvent {
  const OnPlayerAdded(this.player);

  final Player player;

  @override
  List<Object?> get props => [player];
}

class OnPointsAdded extends SessionEvent {
  const OnPointsAdded(this.points);

  final DrawingPointsWrapper points;

  @override
  List<Object?> get props => [points];
}

class OnPlayerDisconnect extends SessionEvent {
  const OnPlayerDisconnect(this.player);

  final Player player;

  @override
  List<Object?> get props => [player];
}

class OnMessageSent extends SessionEvent {
  const OnMessageSent(this.chat);

  final ChatModel chat;

  @override
  List<Object?> get props => [chat];
}

class OnTimerUpdate extends SessionEvent {
  const OnTimerUpdate(this.timer);

  final int timer;

  @override
  List<Object?> get props => [timer];
}
