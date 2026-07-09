import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/api/api_client/api_client.dart';
import '../model/about_model.dart';

class AboutState {
  final bool isLoading;
  final bool isLoaded;
  final String? error;
  final AboutModel? data;

  const AboutState({
    this.isLoading = false,
    this.isLoaded = false,
    this.error,
    this.data,
  });

  AboutState copyWith({
    bool? isLoading,
    bool? isLoaded,
    String? error,
    AboutModel? data,
  }) {
    return AboutState(
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      data: data ?? this.data,
    );
  }
}

class AboutNotifier extends StateNotifier<AboutState> {
  AboutNotifier() : super(const AboutState());

  Future<void> loadAboutUs() async {
    state = state.copyWith(isLoading: true, isLoaded: false, error: null);

    try {
      final response = await ApiClient().get('api/customer/about-us');
      print(response);
      if (response['status'] == 'success' || response['success'] == true || response['status'] == 1) {
        dynamic rawData = response['data'];
        
        // Handle double-wrapped data if present
        if (rawData != null && rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }

        if (rawData != null && rawData is Map<String, dynamic>) {
          state = state.copyWith(
            isLoading: false,
            isLoaded: true,
            data: AboutModel.fromJson(rawData),
          );
        } else {
           state = state.copyWith(isLoading: false, error: 'No data found.');
        }
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to load data.');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final aboutNotifierProvider = StateNotifierProvider<AboutNotifier, AboutState>((ref) {
  return AboutNotifier();
});
