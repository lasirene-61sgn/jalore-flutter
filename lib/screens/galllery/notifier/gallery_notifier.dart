import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/galllery/model/gallery_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/services/api/api_client/api_client.dart';
import 'package:flutter_app/services/api/repo/repo.dart';

/// ======================
/// STATE
/// ======================
class GalleryState {
  final bool isLoading;
  final bool isSaving;
  final bool isLoaded;
  final String? error;
  final List<GalleryModel> galleryList;
  final GalleryModel? selectedGallery;

  const GalleryState({
    this.isLoading = false,
    this.isSaving = false,
    this.isLoaded = false,
    this.error,
    this.galleryList = const [],
    this.selectedGallery,
  });

  GalleryState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isLoaded,
    String? error,
    List<GalleryModel>? galleryList,
    GalleryModel? selectedGallery,
  }) {
    return GalleryState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      galleryList: galleryList ?? this.galleryList,
      selectedGallery: selectedGallery ?? this.selectedGallery,
    );
  }
}

/// ======================
/// NOTIFIER
/// ======================
class GalleryNotifier extends StateNotifier<GalleryState> {
  GalleryNotifier() : super(const GalleryState());

  /// ======================
  /// LOAD GALLERY LIST
  /// ======================
  Future<void> loadGallery() async {
    state = state.copyWith(
      isLoading: true,
      isLoaded: false,
      error: null,
    );

    try {
      final response = await ApiClient().get('api/customer/gallery');
      print("this is Gallery response $response");
      if (response['status'] == 1) {
        final dynamic rawData = response['data']?['data'];

        if (rawData is List) {
          final galleries = rawData
              .map((e) => GalleryModel.fromJson(e))
              .toList();

          state = state.copyWith(
            isLoading: false,
            isLoaded: true,
            galleryList: galleries,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            isLoaded: true,
            galleryList: const [],
          );
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
        error: 'Failed to load gallery: $e',
      );
    }
  }

  /// ======================
  /// CREATE / UPDATE GALLERY
  /// ======================
  Future<void> submitGallery(
      BuildContext context,
      Map<String, dynamic> payload, {
        String? galleryId,
        PlatformFile? profilePhoto,
        PlatformFile? aadharPhoto,
      }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final isCreate = galleryId == null || galleryId.isEmpty;

      final response = await Repo().adminsPost(
        isCreate ? 'POST' : 'PUT',
        isCreate
            ? 'user/Admin/registration/'
            : 'user/Admin/update/$galleryId/',
        payload,
        profilePhoto: profilePhoto,
        aadharPhoto: aadharPhoto,
      );

      if (response['status'] == 1) {
        await loadGallery();
      }
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to save gallery',
      );
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  /// ======================
  /// LOAD SINGLE GALLERY
  /// ======================
  Future<void> loadGalleryDetails(String id) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final response = await Repo().adminDetails(id);
      final gallery = GalleryModel.fromJson(response['data']);

      state = state.copyWith(
        isSaving: false,
        selectedGallery: gallery,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to load gallery details',
      );
    }
  }
}

/// ======================
/// PROVIDER
/// ======================
final galleryNotifierProvider =
StateNotifierProvider<GalleryNotifier, GalleryState>(
      (ref) => GalleryNotifier(),
);
