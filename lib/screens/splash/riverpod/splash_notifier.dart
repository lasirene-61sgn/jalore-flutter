import 'package:flutter_app/screens/splash/model/splash_model.dart';
import 'package:flutter_app/services/api/api_client/api_client.dart';
import 'package:flutter_app/services/local_storage/shared_preference.dart';
import 'package:flutter_app/services/routes/route_name/route_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SplashState {
  final bool isLoading;
  final String? nextRoute;
  final List<SplashImage> images;
  final int currentImageIndex;

  const SplashState({
    this.isLoading = true,
    this.nextRoute,
    this.images = const [],
    this.currentImageIndex = -1,
  });

  SplashState copyWith({
    bool? isLoading,
    String? nextRoute,
    List<SplashImage>? images,
    int? currentImageIndex,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      nextRoute: nextRoute ?? this.nextRoute,
      images: images ?? this.images,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
    );
  }
}


class SplashNotifier extends StateNotifier<SplashState> {
  SplashNotifier() : super(const SplashState()) {
    initSplash();
  }

  Future<void> initSplash() async {
    List<SplashImage> fetchedImages = [];
    try {
      final response = await ApiClient().publicGet("api/customer/v1/mobile-index-images");
      if (response["status"] == 1) {
        final splashResp = SplashResponse.fromJson(response["data"]);
        if (splashResp.success) {
          fetchedImages = splashResp.data;
        }
      }
    } catch (e) {
      print("this error for splash screen listing to your reference :$e");
    }

    if (fetchedImages.isNotEmpty) {
      // Static splash only needs to show for half of the usual duration (e.g., 1 second)
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(images: fetchedImages);

      for (int i = 0; i < fetchedImages.length; i++) {
        state = state.copyWith(currentImageIndex: i);
        // Show each image for its specified duration
        await Future.delayed(Duration(seconds: fetchedImages[i].seconds));
      }
    } else {
      // Show static splash for the full 2 seconds if no dynamic images exist
      await Future.delayed(const Duration(seconds: 2));
    }

    await checkLogin();
  }

  Future<void> checkLogin() async {
    final token = SharedPreferencesHelper().getString("token");
    if (token != null && token.isNotEmpty) {
      state = state.copyWith(
        isLoading: false,
        nextRoute: AppRoutes.home,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        nextRoute: AppRoutes.login,
      );
    }
  }
}

/// ======================
/// PROVIDER
/// ======================
final splashNotifierProvider = StateNotifierProvider<SplashNotifier, SplashState>(
  (ref) => SplashNotifier(),
);
