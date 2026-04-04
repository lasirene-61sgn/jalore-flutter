import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/dashboard/model/banner_model.dart';
import 'package:flutter_app/screens/dashboard/model/dashboard_model.dart';
import 'package:flutter_app/screens/dashboard/model/notifiction_model.dart';
import 'package:flutter_app/services/local_storage/shared_preference.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/services/api/api_client/api_client.dart';
import 'package:flutter_app/services/api/repo/repo.dart';

class DashboardState {
  final bool isLoading;
  final bool isSaving;
  final bool isLoaded;
  final String? error;

  final List<BirthdayModel> birthdayList;
  final List<BirthdayModel> anniversaryList;
  final List<AppNotification> notification;
  final List<BannerModel> banners;


  const DashboardState({
    this.isLoading = false,
    this.isSaving = false,
    this.isLoaded = false,
    this.error,
    this.birthdayList = const [],
    this.anniversaryList = const [],
    this.notification = const [],
    this.banners = const [],
  });

  DashboardState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isLoaded,
    String? error,
    List<BirthdayModel>? birthdayList,
    List<BirthdayModel>? anniversaryList,
    List<AppNotification>? notification,
    List<BannerModel>? banners,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      birthdayList: birthdayList ?? this.birthdayList,
      anniversaryList: anniversaryList ?? this.anniversaryList,
      notification: notification ?? this.notification,
      banners: banners ?? this.banners,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(const DashboardState());

  /// ======================
  /// LOAD BIRTHDAY LIST
  /// ======================
  Future<void> loadBirthdays() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiClient().get('api/customer/today-birthdays');

      if (response['status'] == 1) {
        final rawData = response['data']?['data'] as List? ?? [];

        final list =
        rawData.map((e) => BirthdayModel.fromJson(e)).toList();

        state = state.copyWith(
          isLoading: false,
          isLoaded: true,
          birthdayList: list,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load birthdays',
      );
    }
  }

  Future<void> loadBanner() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiClient().get('api/customer/banner');

      if (response['status'] == 1) {
        final rawData = response['data']?['data'] as List? ?? [];

        final list =
        rawData.map((e) => BannerModel.fromJson(e)).toList();
        print("this is a banner : $list");

        state = state.copyWith(
          isLoading: false,
          isLoaded: true,
          banners: list,
        );
      }
      else{
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load banner',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load birthdays',
      );
    }
  }
  Future<void> loadNotification() async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final response =
      await ApiClient().get('api/customer/all-notifications');

      if (response['status'] == 1) {
        final rawData = response['data']?['data'] as List? ?? [];

        final list =
        rawData.map((e) => AppNotification.fromJson(e)).toList();

        state = state.copyWith(
          isSaving: false,
          notification: list,
        );

        // // Optional: mark unread ones (without reloading again)
        // final unread = list.where((e) => e.data?.isRead == false).toList();
        //
        // for (var item in unread) {
        //   await loadNotificationPost(item.data!.id.toString());
        // }
      }
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to load notifications',
      );
    }
  }
  Future<void> loadNotificationPost() async {
    try {
      // 1. Call the API to mark all as read on the server
      final response = await ApiClient()
          .post(url: 'api/customer/notifications/mark-all-read');

      if (response['status'] == 1) {
        await loadNotification();
        // 2. Map through the current notifications in state
        // final updatedList = state.notification.map((item) {
        //   // 3. Use copyWith to set the root isRead to true
        //   return item.copyWith(
        //     isRead: true,
        //     // Also update nested data if your model still uses it
        //     data: item.data?.copyWith(isRead: true),
        //   );
        // }).toList();
        //
        // // 4. Update the state with the new list
        // state = state.copyWith(notification: updatedList);
      }
    } catch (e) {
      debugPrint("Error marking notifications as read: ${e.toString()}");
    }
  }
  Future<void> loadSingleNotificationPost(String id) async {
    try {
      // 1. Call the API to mark all as read on the server
      final response = await ApiClient()
          .post(url: 'api/customer/notifications/$id/read');
    print("marking Single notifications as read: $response");
      if (response['status'] == 1) {
        await loadNotification();

      }
    } catch (e) {
      debugPrint("Error marking notifications as read: ${e.toString()}");
    }
  }

  Future<void> loadAnniversaries() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiClient().get('api/customer/today-anniversaries');

      if (response['status'] == 1) {
        final rawData = response['data']?['data'] as List? ?? [];

        final list =
        rawData.map((e) => BirthdayModel.fromJson(e)).toList();

        state = state.copyWith(
          isLoading: false,
          isLoaded: true,
          anniversaryList: list,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load anniversaries',
      );
    }
  }
}


final dashboardNotifierProvider =
StateNotifierProvider<DashboardNotifier, DashboardState>(
      (ref) => DashboardNotifier(),
);
