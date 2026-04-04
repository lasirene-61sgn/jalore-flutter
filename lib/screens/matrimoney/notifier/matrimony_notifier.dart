import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/matrimoney/model/matrimony_model.dart';
import 'package:flutter_app/services/api/api_client/api_client.dart';
import 'package:flutter_app/services/api/repo/repo.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ======================
/// STATE
/// ======================
class MatrimoneyState {
  final bool isLoading;
  final String? error;
  final List<Matrimoney> matrimoneyList;

  // Filters
  final String? ageFilter; // null = All
  final String? genderFilter;
  final int? startAge;
  final int? endAge;

  const MatrimoneyState({
    this.isLoading = false,
    this.error,
    this.matrimoneyList = const [],
    this.ageFilter,
    this.genderFilter,
    this.startAge,
    this.endAge,
  });

  /// 🔥 Helper: ALL means NO restriction
  bool get isAllAge =>
      ageFilter == null && startAge == null && endAge == null;

  /// ======================
  /// FILTERED LIST (FINAL)
  /// ======================
  List<Matrimoney> get filteredList {
    return matrimoneyList.where((item) {
      /// Gender filter
      final matchesGender = genderFilter == null ||
          item.familyMemberGender?.toLowerCase() ==
              genderFilter!.toLowerCase();

      /// Age filter
      final age = item.familyMemberAge ?? 0;
      bool matchesAge = true;

      // 🟢 ALL = NO restriction (ALWAYS)
      if (isAllAge) {
        matchesAge = true;
      }
      // 1️⃣ Quick age filter
      else if (ageFilter != null) {
        switch (ageFilter) {
          case '18-25':
            matchesAge = age >= 18 && age <= 25;
            break;
          case '20-24':
            matchesAge = age >= 20 && age <= 24;
            break;
          case '25-30':
            matchesAge = age >= 25 && age <= 30;
            break;
          default:
            matchesAge = age.toString() == ageFilter;
        }
      }
      // 2️⃣ Custom range
      else if (startAge != null && endAge != null) {
        matchesAge = age >= startAge! && age <= endAge!;
      }

      return matchesGender && matchesAge;
    }).toList();
  }

  /// ======================
  /// COPY WITH
  /// ======================
  MatrimoneyState copyWith({
    bool? isLoading,
    String? error,
    List<Matrimoney>? matrimoneyList,
    String? ageFilter,
    bool clearAgeFilter = false,
    String? genderFilter,
    bool clearGender = false,
    int? startAge,
    int? endAge,
    bool clearAge = false,
  }) {
    return MatrimoneyState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      matrimoneyList: matrimoneyList ?? this.matrimoneyList,
      ageFilter: clearAgeFilter ? null : (ageFilter ?? this.ageFilter),
      genderFilter: clearGender ? null : (genderFilter ?? this.genderFilter),
      startAge: clearAge ? null : (startAge ?? this.startAge),
      endAge: clearAge ? null : (endAge ?? this.endAge),
    );
  }
}
class MatrimoneyNotifier extends StateNotifier<MatrimoneyState> {
  MatrimoneyNotifier() : super(const MatrimoneyState());

  /// 🔄 Reset ONLY age (used by "All")
  void clearAgeFilters() {
    state = state.copyWith(
      clearAgeFilter: true,
      clearAge: true,
    );
  }

  /// 🔄 Reset EVERYTHING (used by refresh button)
  void clearAllFilters() {
    state = state.copyWith(
      clearAgeFilter: true,
      clearAge: true,
      clearGender: true,
    );
  }

  /// Gender
  void setGenderFilter(String? gender) {
    state = state.copyWith(
      genderFilter: gender,
      clearGender: gender == null,
    );
  }

  /// Custom age range
  void setCustomAgeRange(int? start, int? end) {
    state = state.copyWith(
      startAge: start,
      endAge: end,
      clearAgeFilter: true, // remove quick filter
    );
  }

  /// Quick age filter
  void setAgeFilter(String? age) {
    state = state.copyWith(
      ageFilter: age,
      clearAgeFilter: age == null,
      clearAge: age != null, // remove custom range
    );
  }

  /// API
  Future<void> loadMatrimoney(String url) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiClient().get(url);

      if (response['status'] == 1) {
        final data = response['data']?['data'];

        state = state.copyWith(
          isLoading: false,
          matrimoneyList: data is List
              ? data.map((e) => Matrimoney.fromJson(e)).toList()
              : [],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Server error',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

/// ======================
final matrimoneyNotifierProvider =
StateNotifierProvider<MatrimoneyNotifier, MatrimoneyState>(
      (ref) => MatrimoneyNotifier(),
);
