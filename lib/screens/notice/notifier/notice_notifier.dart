import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/notice/model/notice_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/services/api/api_client/api_client.dart';
import 'package:flutter_app/services/api/repo/repo.dart';

/// ======================
/// STATE
/// ======================
class NoticeState {
  final bool isLoading;
  final bool isSaving;
  final bool isLoaded;
  final String? error;
  final List<Notice> noticeList;
  final Notice? selectedNotice;

  const NoticeState({
    this.isLoading = false,
    this.isSaving = false,
    this.isLoaded = false,
    this.error,
    this.noticeList = const [],
    this.selectedNotice,
  });

  NoticeState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isLoaded,
    String? error,
    List<Notice>? noticeList,
    Notice? selectedNotice,
  }) {
    return NoticeState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      noticeList: noticeList ?? this.noticeList,
      selectedNotice: selectedNotice ?? this.selectedNotice,
    );
  }
}

/// ======================
/// NOTIFIER
/// ======================
class NoticeNotifier extends StateNotifier<NoticeState> {
  NoticeNotifier() : super(const NoticeState());

  /// Load Notice List
  Future<void> loadNotices() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiClient().get('api/customer/notice');

      if (response['status'] == 1) {
        final rawData = response['data']?['data'];

        if (rawData is List) {
          final notices = rawData
              .map((e) => Notice.fromJson(e as Map<String, dynamic>))
              .toList();

          state = state.copyWith(
            isLoading: false,
            isLoaded: true,
            noticeList: notices,
          );
        } else {
          state = state.copyWith(isLoading: false, noticeList: []);
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Server returned error status',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load notices',
      );
    }
  }

  /// Create / Update Notice
  Future<void> submitNotice(
      BuildContext context,
      Map<String, dynamic> payload, {
        String? noticeId,
        PlatformFile? profilePhoto,
        PlatformFile? aadharPhoto,
      }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final isCreate = noticeId == null || noticeId.isEmpty;

      final response = await Repo().adminsPost(
        isCreate ? 'POST' : 'PUT',
        isCreate
            ? 'user/Admin/registration/'
            : 'user/Admin/update/$noticeId/',
        payload,
        profilePhoto: profilePhoto,
        aadharPhoto: aadharPhoto,
      );

      if (response['status'] == 1) {
        await loadNotices();
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to save notice');
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  /// Load Single Notice
  Future<void> loadNoticeDetails(String id) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final response = await Repo().adminDetails(id);
      final notice = Notice.fromJson(response['data']);

      state = state.copyWith(
        isSaving: false,
        selectedNotice: notice,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to load notice details',
      );
    }
  }
}

/// ======================
/// PROVIDER
/// ======================
final noticeNotifierProvider =
StateNotifierProvider<NoticeNotifier, NoticeState>(
      (ref) => NoticeNotifier(),
);
