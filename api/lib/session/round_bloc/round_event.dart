part of 'round_bloc.dart';

abstract class RoundEvent extends Equatable {
  const RoundEvent();
}

class OnRoundStarted extends RoundEvent {
  const OnRoundStarted();

  @override
  List<Object> get props => [];
}

class OnRoundEnded extends RoundEvent {
  const OnRoundEnded();

  @override
  List<Object> get props => [];
}

class OnGameEnded extends RoundEvent{
  const OnGameEnded();

  @override
  List<Object?> get props => [];


}
class AddPlayer extends RoundEvent {
  const AddPlayer({required this.player});

  final Player player;

  @override
  List<Object> get props => [player];
}

class PlayerDisconnected extends RoundEvent {
  const PlayerDisconnected({required this.playerUid});

  final String playerUid;

  @override
  List<Object> get props => [playerUid];
}

class OnTimerUpdate extends RoundEvent {
  const OnTimerUpdate({required this.duration});

  final int duration;

  @override
  List<Object?> get props => [duration];
}

class OnTimerCancel extends RoundEvent {
  const OnTimerCancel();

  @override
  List<Object> get props => [];
}

class OnTimerStart extends RoundEvent {
  const OnTimerStart();

  @override
  List<Object> get props => [];
}
