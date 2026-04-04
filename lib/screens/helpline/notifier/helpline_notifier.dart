import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/screens/helpline/model/helpline_model.dart';
import 'package:flutter_app/services/api/api_client/api_client.dart';

class HelplineState {
  final bool isLoading;
  final List<HelplineCategory> helplineList;
  final String? error;

  HelplineState({
    this.isLoading = false,
    this.helplineList = const [],
    this.error,
  });

  HelplineState copyWith({
    bool? isLoading,
    List<HelplineCategory>? helplineList,
    String? error,
  }) {
    return HelplineState(
      isLoading: isLoading ?? this.isLoading,
      helplineList: helplineList ?? this.helplineList,
      error: error,
    );
  }
}

class HelplineNotifier extends StateNotifier<HelplineState> {
  HelplineNotifier() : super(HelplineState());

  Future<void> loadHelpline() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiClient().get('api/customer/helpline');
      print("this is Helpline response $response");

      if (response['status'] == 'success' || response['status'] == 1) {
        dynamic rawData = response['data'] ?? [];
        // Handle double nesting if response['data'] is a Map with another 'data' key
        if (rawData is Map && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        
        if (rawData is List) {
          final helplineList = rawData.map((e) => HelplineCategory.fromJson(e)).toList();
          state = state.copyWith(isLoading: false, helplineList: helplineList);
        } else {
          state = state.copyWith(isLoading: false, error: 'Invalid data format');
        }
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to load helpline');
      }
    } catch (e) {
      print("this is Helpline response ${e.toString()}");
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final helplineNotifierProvider = StateNotifierProvider<HelplineNotifier, HelplineState>((ref) {
  return HelplineNotifier();
});
