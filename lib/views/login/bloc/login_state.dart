part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class InitialState extends LoginState {
  const InitialState();

  @override
  List<Object> get props => [];
}

class LoadingState extends LoginState {
  const LoadingState();

  @override
  List<Object> get props => [];
}

class ErrorState extends LoginState {

  const ErrorState({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}

class LoginSuccessFullState extends LoginState {
  const LoginSuccessFullState({required this.playerUid});
  final String playerUid;
  @override
  List<Object> get props => [playerUid];
}
