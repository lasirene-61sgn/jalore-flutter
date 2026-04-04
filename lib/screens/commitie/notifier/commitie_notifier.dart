import 'package:flutter_app/screens/commitie/model/commitie_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/services/api/api_client/api_client.dart';

/// ======================
/// STATE
/// ======================
class CommitteeState {
  final bool isLoading;
  final bool isSaving;
  final bool isLoaded;
  final String? error;
  final List<CommitteeMember> committeeList;
  final CommitteeMember? selectedCommittee;

  const CommitteeState({
    this.isLoading = false,
    this.isSaving = false,
    this.isLoaded = false,
    this.error,
    this.committeeList = const [],
    this.selectedCommittee,
  });

  CommitteeState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isLoaded,
    String? error,
    List<CommitteeMember>? committeeList,
    CommitteeMember? selectedCommittee,
  }) {
    return CommitteeState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      committeeList: committeeList ?? this.committeeList,
      selectedCommittee: selectedCommittee ?? this.selectedCommittee,
    );
  }
}
class CommitteeNotifier extends StateNotifier<CommitteeState> {
  CommitteeNotifier() : super(const CommitteeState());

  /// Load Committee List
  Future<void> loadCommittee() async {
    state = state.copyWith(isLoading: true, isLoaded: false, error: null);

    try {
      final response = await ApiClient().get('api/customer/committee');

      if (response['status'] == 1) {
        final List rawList = response['data']?['data'] ?? [];

        final committees = rawList
            .map((e) => CommitteeMember.fromJson(e as Map<String, dynamic>))
            .toList();

        state = state.copyWith(
          isLoading: false,
          isLoaded: true,
          committeeList: committees,
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
        error: 'Failed to load committee',
      );
    }
  }

  /// Load Single Committee
  Future<void> loadCommitteeDetails(String id) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final response = await ApiClient().get('api/customer/event/$id');
      final committee = CommitteeMember.fromJson(response['data']);

      state = state.copyWith(
        isSaving: false,
        selectedCommittee: committee,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to load committee details',
      );
    }
  }
}
final committeeNotifierProvider =
StateNotifierProvider<CommitteeNotifier, CommitteeState>(
      (ref) => CommitteeNotifier(),
);
