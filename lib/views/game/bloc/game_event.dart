part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class ConnectGame extends GameEvent {
  const ConnectGame();

  @override
  List<Object> get props => [];
}

class OnMapData extends GameEvent {
  const OnMapData({required this.roundData});

  final Map<String,dynamic> roundData;

  @override
  List<Object> get props => [roundData];
}

class AddPlayer extends GameEvent {
  const AddPlayer({required this.playerUid});

  final String playerUid;

  @override
  List<Object> get props => [playerUid];
}
