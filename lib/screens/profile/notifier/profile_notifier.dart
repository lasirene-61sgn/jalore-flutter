import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/profile/model/family_member_model.dart';
import 'package:flutter_app/screens/profile/model/profile_model.dart';
import 'package:flutter_app/services/api/api_client/api_client.dart';
import 'package:flutter_app/services/api/repo/repo.dart';
import 'package:flutter_app/services/widget/custom_msg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/screens/events/model/event_model.dart';

class ProfileState {
  final bool isLoading;
  final bool isSaving;
  final bool isLoaded;
  final String? error;

  final Profile? profile;          // ✅ Single profile
  final List<FamilyMember>? familyMember;          // ✅ Single profile
  final Profile? selectedProfile;  // ✅ For edit/view

  const ProfileState({
    this.isLoading = false,
    this.isSaving = false,
    this.isLoaded = false,
    this.error,
    this.profile,
    this.selectedProfile,
    this.familyMember,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isLoaded,
    String? error,
    Profile? profile,
    List<FamilyMember>? familyMember,
    Profile? selectedProfile,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      profile: profile ?? this.profile,
      familyMember: familyMember ?? this.familyMember,
      selectedProfile: selectedProfile ?? this.selectedProfile,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super( ProfileState());

  /// ======================
  /// LOAD PROFILE
  /// ======================
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiClient().get('api/customer/profile');

      if (response['status'] == 1 && response['data']?['data'] != null) {
        final profile = Profile.fromJson(response['data']?['data']);

        state = state.copyWith(
          isLoading: false,
          isLoaded: true,
          profile: profile,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid profile response',
        );
      }
    } catch (e, s) {
      debugPrint("PROFILE LOAD ERROR: $e");
      debugPrintStack(stackTrace: s);

      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load profile',
      );
    }
  }
  Future<void> loadMember() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiClient().get('api/customer/family-members/');

      // Check if data is a List
      if (response['status'] == 1 && response['data']?['data'] != null) {
        final List<dynamic> dataList = response['data']['data'];

        // Map the list to FamilyMember objects
        final members = dataList.map((item) => FamilyMember.fromJson(item)).toList();

        state = state.copyWith(
          isLoading: false,
          isLoaded: true,
          familyMember: members, // ✅ Assign to familyMember list, not profile
        );
      } else {
        state = state.copyWith(isLoading: false, error: 'No family data found');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load family');
    }
  }

  /// ======================
  /// CREATE / UPDATE PROFILE
  /// ======================
  // Future<void> submitProfile(
  //     BuildContext context,
  //     Map<String,dynamic> payload,
  //     File? profileImage,
  //     ) async {
  //   state = state.copyWith(isSaving: true, error: null);
  //
  //   try {
  //
  //     dynamic response = await ApiClient().put(
  //       url:'api/customer/profile',
  //       map: payload,
  //     );
  //
  //     if (response['status'] == 1) {
  //       await loadProfile();
  //       state = state.copyWith(isSaving: false, error: null);
  //       Toaster.showSuccess(response['data']['message'].toString());
  //     } else {
  //       throw Exception('Profile save failed');
  //     }
  //   } catch (e) {
  //     state = state.copyWith(
  //       isSaving: false,
  //       error: 'Failed to save profile',
  //     );
  //   } finally {
  //     state = state.copyWith(isSaving: false);
  //   }
  // }
  Future<void> submitProfile(
      BuildContext context,
      Map<String, dynamic> payload,
      File? profileImage,
      ) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final response = await ApiClient().putWithFiles(
        url: 'api/customer/profile',
        method: 'PUT',
        map: payload,
        files: {
          if (profileImage != null) 'image': profileImage,
        },
      );

      if (response['status'] == "success") {
        await loadProfile();
        state = state.copyWith(isSaving: false, error: null);
        Toaster.showSuccess(response['message'].toString());
      } else {
        state = state.copyWith(
          isSaving: false,
        );
        Toaster.showError(response['message'].toString());
      }
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addFamily(
      BuildContext context,
      File? profileImage,
      Map<String,dynamic> payload) async {
    state = state.copyWith(isSaving: true, error: null);

    try {

      dynamic response =  await ApiClient().putWithFiles(
        method: 'POST',
        map: payload,
        files: {
          if (profileImage != null) 'image': profileImage,
        },
        url:'api/customer/family-members',
      );


      if (response['status'] == 'success') {
       await loadMember();
        state = state.copyWith(isSaving: false, error: null);
       Toaster.showSuccess(response['message'].toString());
      } else {
        state = state.copyWith(isSaving: false, error: null);
        Toaster.showError(response['message'].toString());
      }
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to save profile',
      );
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  Future<void> updateFamily(
      BuildContext context,
      String memberId,
      File? profileImage,
      Map<String, dynamic> payload) async {

    state = state.copyWith(isSaving: true, error: null);

    try {
      // Typically PUT requests for specific items include the ID in the URL
      // e.g., api/customer/family-members/1
      final response = await ApiClient().putWithFiles(
        url: 'api/customer/family-members/$memberId',
        method: 'PUT',
        map: payload,
        files: {
          if (profileImage != null) 'image': profileImage,
        },
      );

      if (response['status'] == "success") {
        await loadMember();
        state = state.copyWith(isSaving: false, error: null);
        Toaster.showSuccess(response['message'].toString());

      } else {
        state = state.copyWith(isSaving: false, error: null);
        Toaster.showError(response['message'].toString());
      }
    } catch (e) {
      debugPrint("UPDATE FAMILY ERROR: $e");
      state = state.copyWith(
          isSaving: false,
          error: 'Failed to update family member'
      );
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
  Future<void> loadProfileDetails(String id) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final response = await Repo().adminDetails(id);

      if (response['data'] != null) {
        final profile = Profile.fromJson(response['data']);

        state = state.copyWith(
          isSaving: false,
          selectedProfile: profile,
        );
      } else {
        throw Exception('No profile data');
      }
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to load profile details',
      );
    }
  }
}


final profileNotifierProvider =
StateNotifierProvider<ProfileNotifier, ProfileState>(
      (ref) => ProfileNotifier(),
);
