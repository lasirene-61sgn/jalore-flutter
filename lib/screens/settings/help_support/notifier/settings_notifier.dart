import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/settings/help_support/model/support_model.dart';
import 'package:flutter_app/services/api/api_client/api_client.dart';
import 'package:flutter_app/services/api/repo/repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class SettingsState {
  final bool isLoading;
  final bool isSaving;
  final bool isLoaded;
  final String? error;
  final SupportProfile? profile;
  final SupportProfile? selectedProfile;

  const SettingsState({
    this.isLoading = false,
    this.isSaving = false,
    this.isLoaded = false,
    this.error,
    this.profile,
    this.selectedProfile,
  });

  SettingsState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isLoaded,
    String? error,
    SupportProfile? profile,
    SupportProfile? selectedProfile,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      profile: profile ?? this.profile,
      selectedProfile: selectedProfile ?? this.selectedProfile,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  final ApiClient _apiClient = ApiClient();

  /// Load Main Settings/Profile Data
  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get('api/customer/support');

      if (response['status'] == 1 && response['data']?['data'] != null) {
        final profile = SupportProfile.fromJson(response['data']?['data']);
        state = state.copyWith(
          isLoading: false,
          isLoaded: true,
          profile: profile,
        );
      } else {
        state = state.copyWith(isLoading: false, error: 'Invalid response');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load settings');
    }
  }

  /// Update Settings/Profile Data
  Future<void> submitSettings(BuildContext context, Map<String, dynamic> payload) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      // Added await here to ensure response is received
      final response = await _apiClient.put(
        url: 'api/customer/profile',
        map: payload,
      );

      if (response != null && response['status'] == 1) {
        await loadSettings(); // Refresh local data
        state = state.copyWith(isSaving: false);
      } else {
        throw Exception('Save failed');
      }
    } catch (e) {
      state = state.copyWith(isSaving: false, error: 'Failed to save');
    }
  }
  Future<void> sendNotification(BuildContext context, Map<String, dynamic> payload) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      // Added await here to ensure response is received
      final response = await _apiClient.headerLessPost(
        url: 'api/customer/profile',
        map: payload,
      );

      if (response != null && response['status'] == 1) {
        await loadSettings(); // Refresh local data
        state = state.copyWith(isSaving: false);
      } else {
        throw Exception('Save failed');
      }
    } catch (e) {
      state = state.copyWith(isSaving: false, error: 'Failed to save');
    }
  }

  /// Load Specific Details for editing
  Future<void> loadSettingsDetails(String id) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      final response = await Repo().adminDetails(id);
      if (response['data'] != null) {
        final profile = SupportProfile.fromJson(response['data']);
        state = state.copyWith(isSaving: false, selectedProfile: profile);
      }
    } catch (e) {
      state = state.copyWith(isSaving: false, error: 'Failed to load details');
    }
  }
}

// Final Provider
final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
      (ref) => SettingsNotifier(),
);