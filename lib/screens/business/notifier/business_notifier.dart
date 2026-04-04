import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/business/model/business_model.dart';
import 'package:flutter_app/screens/business/model/category_model.dart';
import 'package:flutter_app/services/api/api_client/api_client.dart';
import 'package:flutter_app/services/api/repo/repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// ======================
/// STATE
/// ======================
class BusinessState {
  final bool isLoading;
  final bool isSaving;
  final bool isLoaded;
  final String? error;
  final List<Business> businessList;
  final List<Category> category;

  const BusinessState({
    this.isLoading = false,
    this.isSaving = false,
    this.isLoaded = false,
    this.error,
    this.businessList = const [],
    this.category = const [],
  });

  BusinessState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isLoaded,
    String? error,
    List<Business>? businessList,
    List<Category>? category,
  }) {
    return BusinessState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      businessList: businessList ?? this.businessList,
      category: category ?? this.category,
    );
  }
}

/// ======================
/// NOTIFIER
/// ======================
class BusinessNotifier extends StateNotifier<BusinessState> {
  BusinessNotifier() : super(const BusinessState());

  Future<void> loadBusiness(String url) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final response = await ApiClient().get(url);

      if (response["status"] == 1) {
        final dynamic rawData = response['data']?['data'];

        if (rawData is List) {
          final businesses =
          rawData.map((e) => Business.fromJson(e)).toList();

          state = state.copyWith(
            isLoading: false,
            businessList: businesses,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            businessList: [],
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
        error: 'Failed to load business: $e',
      );
    }
  }
  Future<void> loadCategory(String url) async {
    state = state.copyWith(
      isLoaded: true,
      error: null,
    );

    try {
      final response = await ApiClient().get(url);

      if (response["status"] == 1) {
        final dynamic rawData = response['data']?['data'];

        if (rawData is List && rawData.isNotEmpty) {
          final categories =
          rawData.map((e) => Category.fromJson(e)).toList();

          final allCategory = Category(
            id: 0,
            categoryName: 'All',
          );

          final updatedList = [allCategory, ...categories];

          state = state.copyWith(
            isLoaded: false,
            category: updatedList,
          );
        } else {
          state = state.copyWith(
            isLoaded: false,
            businessList: [],
          );
        }
      } else {
        state = state.copyWith(
          isLoaded: false,
          error: 'Server returned error status',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load business: $e',
      );
    }
  }
}

/// ======================
/// PROVIDER
/// ======================
final businessNotifierProvider =
StateNotifierProvider<BusinessNotifier, BusinessState>(
      (ref) => BusinessNotifier(),
);
