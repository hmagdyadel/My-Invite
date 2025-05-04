import 'package:app/features/home/logic/home_states.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../core/helpers/app_utilities.dart';
import '../data/models/profile_response.dart';
import '../data/repo/home_repo.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepo _homeRepo;
  bool _mounted = true;

  HomeCubit(this._homeRepo) : super(const HomeStates.initial()) {
    getProfileData();
  }

  @override
  Future<void> close() async {
    _mounted = false;
    await super.close();
  }

  void getProfileData() async {
    if (!_mounted || isClosed) return;
    emit(const HomeStates.loading());

    final response = await _homeRepo.getProfile();
    if (!_mounted || isClosed) return;

    response.when(
        success: (response) {
          if (!_mounted || isClosed) return;
          if (AppUtilities().loginData.roleName != "Client") {
            subscribeToTopic(response);
          }
          emit(HomeStates.success(response));
        },
        failure: (error) {
          if (!_mounted || isClosed) return;
          emit(HomeStates.error(message: error.toString()));
        }
    );
  }

  void subscribeToTopic(ProfileResponse response) async {
    if (!_mounted || isClosed) return;

    final profile = response;
    final topicToSubscribe = profile.cityId.toString();
    final topicSubscribed = AppUtilities().subscriptionTopic;
    final msg = FirebaseMessaging.instance;

    try {
      await _handleTopicSubscription(
        msg: msg,
        currentTopic: topicSubscribed,
        newTopic: topicToSubscribe,
      );
    } catch (e) {
      if (!_mounted || isClosed) return;
      debugPrint("Subscription failed: ${e.toString()} ❌");
    }
  }

  Future<void> _handleTopicSubscription({
    required FirebaseMessaging msg,
    required String currentTopic,
    required String newTopic,
  }) async {
    // If already subscribed to the correct topic, do nothing
    if (currentTopic == newTopic && currentTopic.isNotEmpty) {
      debugPrint("Already subscribed to topic: $newTopic ✅");
      return;
    }

    // Unsubscribe from old topic if it exists
    if (currentTopic.isNotEmpty) {
      await msg.unsubscribeFromTopic(currentTopic);  // Fixed to use currentTopic
      debugPrint("Unsubscribed from previous topic: $currentTopic ❌");
    }

    // Subscribe to new topic
    await msg.subscribeToTopic(newTopic);
    debugPrint(
        currentTopic.isEmpty
            ? "Subscribed to topic (first time): $newTopic ✅"
            : "Subscribed to new topic: $newTopic ✅"
    );

    // Save new topic
    AppUtilities().subscriptionTopic = newTopic;
    debugPrint("Updated saved topic: $newTopic 📌");
  }
}
