part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  const OnboardingState({this.uniqueRoomId, this.isLoading});
  final String? uniqueRoomId;
  final bool? isLoading;
  @override
  List<Object?> get props => [uniqueRoomId, isLoading];

  OnboardingState copyWith({String? uniqueRoomId, bool? isLoading}) {
    return OnboardingState(
      uniqueRoomId: uniqueRoomId ?? this.uniqueRoomId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
