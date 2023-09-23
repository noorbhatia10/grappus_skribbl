import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:services/services.dart';
part 'onboarding_state.dart';

class RoomResponseModel {
  RoomResponseModel({
    this.data,
    this.message,
    this.status,
  });
  factory RoomResponseModel.fromJson(Map<String, dynamic> json) {
    return RoomResponseModel(
      status: json['status'] as String,
      data: json['data'] as String,
      message: json['message'] as String,
    );
  }

  final String? status;
  final String? data; // here id is the data
  final String? message;
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());
  final _gameService = GameService();
  Future<void> createRoomSession() async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _gameService.createRoom();
      emit(
        state.copyWith(
          uniqueRoomId: RoomResponseModel.fromJson(
            jsonDecode(result.data as String) as Map<String, dynamic>,
          ).data,
        ),
      );
    } catch (e) {
      log(e.toString());
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
