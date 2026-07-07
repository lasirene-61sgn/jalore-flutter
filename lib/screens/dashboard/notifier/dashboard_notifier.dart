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

  final int todayBirthdayCount;
  final Map<String, Map<String, List<BirthdayModel>>> birthdayData;
  final int todayAnniversaryCount;
  final Map<String, Map<String, List<BirthdayModel>>> anniversaryData;
  final List<AppNotification> notification;
  final List<BannerModel> banners;
  final DashboardCountersModel? counters;
  final SocialLinksModel? socialLinks;

  const DashboardState({
    this.isLoading = false,
    this.isSaving = false,
    this.isLoaded = false,
    this.error,
    this.todayBirthdayCount = 0,
    this.birthdayData = const {},
    this.todayAnniversaryCount = 0,
    this.anniversaryData = const {},
    this.notification = const [],
    this.banners = const [],
    this.counters,
    this.socialLinks,
  });

  DashboardState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isLoaded,
    String? error,
    int? todayBirthdayCount,
    Map<String, Map<String, List<BirthdayModel>>>? birthdayData,
    int? todayAnniversaryCount,
    Map<String, Map<String, List<BirthdayModel>>>? anniversaryData,
    List<AppNotification>? notification,
    List<BannerModel>? banners,
    DashboardCountersModel? counters,
    SocialLinksModel? socialLinks,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      todayBirthdayCount: todayBirthdayCount ?? this.todayBirthdayCount,
      birthdayData: birthdayData ?? this.birthdayData,
      todayAnniversaryCount: todayAnniversaryCount ?? this.todayAnniversaryCount,
      anniversaryData: anniversaryData ?? this.anniversaryData,
      notification: notification ?? this.notification,
      banners: banners ?? this.banners,
      counters: counters ?? this.counters,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(const DashboardState());

  /// ======================
  /// LOAD DASHBOARD COUNTERS
  /// ======================
  Future<void> loadDashboardCounters() async {
    try {
      final response = await ApiClient().get('api/customer/dashboard-counters');
      print("dashboard count:${response}");
      if (response["data"]?['status'] == 'success') {
        final countersData = response["data"]?['counters'];
        if (countersData != null) {
          final countersModel = DashboardCountersModel.fromJson(Map<String, dynamic>.from(countersData));
          state = state.copyWith(counters: countersModel);
        }
      }
    } catch (e) {
      debugPrint("Error loading dashboard counters: $e");
    }
  }

  /// ======================
  /// LOAD SOCIAL LINKS
  /// ======================
  Future<void> loadSocialLinks() async {
    try {
      final response = await ApiClient().get('api/customer/social-links');
      if (response['data']?['status'] == 'success') {
        final data = response['data']?['data'];
        if (data != null) {
          final socialLinksModel = SocialLinksModel.fromJson(Map<String, dynamic>.from(data));
          state = state.copyWith(socialLinks: socialLinksModel);
        }
      }
    } catch (e) {
      debugPrint("Error loading social links: $e");
    }
  }

  /// ======================
  /// LOAD BIRTHDAY LIST
  /// ======================
  Future<void> loadBirthdays() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiClient().get('api/customer/today-birthdays');

      if (response['status'] == 'success' || response['status'] == 1) {
        final decoded = response['data'] is Map ? response['data'] : {};
        final int count = decoded['today_count'] ?? 0;
        final rawData = decoded['data'];

        final Map<String, Map<String, List<BirthdayModel>>> map = {};
        if (rawData is Map) {
          rawData.forEach((monthKey, monthData) {
            if (monthData is Map) {
              final Map<String, List<BirthdayModel>> dateMap = {};
              monthData.forEach((dateKey, dateList) {
                if (dateList is List) {
                  final List<BirthdayModel> list = [];
                  for (var item in dateList) {
                    if (item is Map) {
                      try {
                        list.add(BirthdayModel.fromJson(Map<String, dynamic>.from(item)));
                      } catch(e) {
                        debugPrint("Error parsing birthday member in $dateKey: $e");
                      }
                    }
                  }
                  if (list.isNotEmpty) {
                    dateMap[dateKey.toString()] = list;
                  }
                }
              });
              map[monthKey.toString()] = dateMap;
            }
          });
        }

        state = state.copyWith(
          isLoading: false,
          isLoaded: true,
          todayBirthdayCount: count,
          birthdayData: map,
        );
      } else {
         state = state.copyWith(
          isLoading: false,
          error: 'Failed to load birthdays',
        );
      }
    } catch (e, stacktrace) {
      debugPrint("Error loading birthdays: $e\n$stacktrace");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load birthdays: $e',
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

    // // 1. Get all preference values
    // bool eventReminders = SharedPreferencesHelper().getBool("event_reminders") ?? false;
    // bool newsReminders = SharedPreferencesHelper().getBool("news_updates") ?? false;
    // bool birthDayReminders = SharedPreferencesHelper().getBool("birthday_reminders") ?? false;
    // bool anniversaryReminders = SharedPreferencesHelper().getBool("anniversary_reminders") ?? false;
    // bool galleryReminders = SharedPreferencesHelper().getBool("gallery_updates") ?? false;
    // print("gallery Reminders  :$galleryReminders");

    try {
      final response = await ApiClient().get('api/customer/all-notifications');

      if (response['status'] == 1) {
        final rawData = response['data']?['data'] as List? ?? [];

        final list = rawData
            .map((e) => AppNotification.fromJson(e)).toList();
        //     .where((notification) {
        //   // 2. Check each type against its specific toggle
        //   switch (notification.type) {
        //     case "event":
        //       return eventReminders;
        //     case "gallery":
        //       return galleryReminders;
        //     case "news":
        //       return newsReminders;
        //     case "anniversary":
        //       return anniversaryReminders;
        //     case "birthday":
        //       return birthDayReminders;
        //     default:
        //     // If the type is unknown, you can choose to show it (true)
        //     // or hide it (false).
        //       return true;
        //   }
        // })
        //     .toList();
        print(list);
        state = state.copyWith(
          isSaving: false,
          notification: list,
        );
      }
    } catch (e) {
      print(" error  ${e.toString()}");
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to load notifications',
      );
    }
  }
  Future<void> loadNotificationPost() async {
    try {
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

      if (response['status'] == 'success' || response['status'] == 1) {
        final decoded = response['data'] is Map ? response['data'] : {};
        final int count = decoded['today_count'] ?? 0;
        final rawData = decoded['data'];
        
        debugPrint("loadAnniversaries: received data of type ${rawData.runtimeType}");

        final Map<String, Map<String, List<BirthdayModel>>> map = {};
        if (rawData is Map) {
          rawData.forEach((monthKey, monthData) {
            if (monthData is Map) {
              final Map<String, List<BirthdayModel>> dateMap = {};
              monthData.forEach((dateKey, dateList) {
                if (dateList is List) {
                  final List<BirthdayModel> list = [];
                  for (var item in dateList) {
                    if (item is Map) {
                      try {
                        list.add(BirthdayModel.fromJson(Map<String, dynamic>.from(item)));
                      } catch(e) {
                        debugPrint("Error parsing anniversary member in $dateKey: $e");
                      }
                    }
                  }
                  if (list.isNotEmpty) {
                    dateMap[dateKey.toString()] = list;
                  }
                }
              });
              map[monthKey.toString()] = dateMap;
            }
          });
        } else {
          debugPrint("loadAnniversaries: rawData is NOT a Map! It is ${rawData.runtimeType}");
        }

        state = state.copyWith(
          isLoading: false,
          isLoaded: true,
          todayAnniversaryCount: count,
          anniversaryData: map,
        );
      } else {
         state = state.copyWith(
          isLoading: false,
          error: 'Failed to load anniversaries',
        );
      }
    } catch (e, stacktrace) {
      debugPrint("Error loading anniversaries: $e\n$stacktrace");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load anniversaries: $e',
      );
    }
  }
}


final dashboardNotifierProvider =
StateNotifierProvider<DashboardNotifier, DashboardState>(
      (ref) => DashboardNotifier(),
);
