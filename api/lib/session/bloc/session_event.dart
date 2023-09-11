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
  const OnPlayerDisconnect(this.uid);

  final String  uid;

  @override
  List<Object?> get props => [uid];
}

class OnMessageSent extends SessionEvent {
  const OnMessageSent(this.chat);

  final ChatModel chat;

  @override
  List<Object?> get props => [chat];
}

class OnRoundStarted extends SessionEvent {
  const OnRoundStarted();

  @override
  List<Object?> get props => [];
}

class OnRoundEnded extends SessionEvent {
  const OnRoundEnded();

  @override
  List<Object?> get props => [];
}

class OnGameEnded extends SessionEvent {
  const OnGameEnded();

  @override
  List<Object?> get props => [];
}

class _TimerTicked extends SessionEvent {
  const _TimerTicked({required this.duration});

  final int duration;

  @override
  List<Object?> get props => [duration];
}
