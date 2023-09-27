part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class AddPlayer extends LoginEvent {
  const AddPlayer({
    required this.playerName,
    required this.imagePath,
    required this.color,
  });

  final String playerName;
  final String imagePath;
  final int color;

  @override
  List<Object> get props => [playerName, imagePath, color];
}

class ErrorEvent extends LoginEvent {
  const ErrorEvent({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}
