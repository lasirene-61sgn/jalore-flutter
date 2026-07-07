import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/matrimony_model.dart';
import '../../../services/api/api_client/api_client.dart';

/// ======================
/// STATE
/// ======================
class MatrimoneyState {
  final bool isLoading;
  final bool isSaving;
  final bool isLoaded;
  final String? error;
  final List<Matrimoney> matrimoneyList;
  final Matrimoney? selectedMatrimoney;

  const MatrimoneyState({
    this.isLoading = false,
    this.isSaving = false,
    this.isLoaded = false,
    this.error,
    this.matrimoneyList = const [],
    this.selectedMatrimoney,
  });

  MatrimoneyState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isLoaded,
    String? error,
    List<Matrimoney>? matrimoneyList,
    Matrimoney? selectedMatrimoney,
  }) {
    return MatrimoneyState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      matrimoneyList: matrimoneyList ?? this.matrimoneyList,
      selectedMatrimoney:
      selectedMatrimoney ?? this.selectedMatrimoney,
    );
  }
}

/// ======================
/// NOTIFIER
/// ======================
class MatrimoneyNotifier
    extends StateNotifier<MatrimoneyState> {
  MatrimoneyNotifier() : super(const MatrimoneyState());

  Future<void> loadMatrimoney(String url) async {
    state = state.copyWith(
      isLoading: true,
      isLoaded: false,
      error: null,
    );

    try {
      final response = await ApiClient().get(url);

      if (response["status"] == 1) {
        print("RAW RESPONSE: $response");

        final dynamic rawData = response['data']?['data'];

        if (rawData != null && rawData is List) {
          final list = rawData
              .map((e) => Matrimoney.fromJson(e))
              .toList();

          print("PARSED MATRIMONEY COUNT: ${list.length}");

          state = state.copyWith(
            isLoading: false,
            isLoaded: true,
            matrimoneyList: list,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            isLoaded: true,
            matrimoneyList: [],
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Server returned error status',
        );
      }
    } catch (e) {
      print("ERROR: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load matrimoney: $e',
      );
    }
  }
}

/// ======================
/// PROVIDER
/// ======================
final matrimoneyNotifierProvider =
StateNotifierProvider<MatrimoneyNotifier, MatrimoneyState>(
      (ref) => MatrimoneyNotifier(),
);
