import 'package:flutter/cupertino.dart';
import 'package:flutter_app/screens/auth/login/model/login_model.dart';
import 'package:flutter_app/screens/auth/otp_verification_screen.dart';
import 'package:flutter_app/screens/auth/set_password_screen.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/services/api/repo/repo.dart';
import 'package:flutter_app/services/local_storage/shared_preference.dart';
import 'package:flutter_app/services/routes/route_name/route_name.dart';
import 'package:flutter_app/services/widget/custom_msg.dart';
import 'package:get/get.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final bool isLoading;         // Global/Login loader
  final bool isOtpLoading;      // Register/First Time loader
  final bool isForgotLoading;   // Forgot Password loader
  final bool isLoggedIn;
  final String? error;
  final String? mobile;
  final String? otp;
  final UserLoginResponse? user;

  const LoginState({
    this.isLoading = false,
    this.isOtpLoading = false,
    this.isForgotLoading = false,
    this.isLoggedIn = false,
    this.error,
    this.mobile,
    this.otp,
    this.user,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isOtpLoading,
    bool? isForgotLoading,
    bool? isLoggedIn,
    String? error,
    String? mobile,
    String? otp,
    UserLoginResponse? user,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isOtpLoading: isOtpLoading ?? this.isOtpLoading,
      isForgotLoading: isForgotLoading ?? this.isForgotLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      error: error ?? this.error,
      mobile: mobile ?? this.mobile,
      otp: otp ?? this.otp,
      user: user ?? this.user,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  Future<void> login(Map map,{String? mobile}) async {
    state = state.copyWith(isLoading: true, error: null,mobile: mobile);

    try {
      final response = await Repo().logIn(map);
      print(response);
      if (response["status"] == 1) {
        final userData = UserLoginResponse.fromJson(response["data"]);
        await SharedPreferencesHelper().init();
        await SharedPreferencesHelper().setBool("isLoggedIn", true);
        await SharedPreferencesHelper().setString("token", userData.token);
        print(" hello:${userData.token}");
        if (userData.token.isNotEmpty) {
          Get.offAllNamed(AppRoutes.home);
          Toaster.showSuccess(userData.message);
        }

        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          user: userData,
        );
      } else {
        Toaster.showError(response['message']?["message"]);
        state = state.copyWith(isLoading: false, error: response['message']?["message"]);
      }
    } catch (e, stackTrace) {
      final errorMsg = "Network error. Please try again.";

      print("Login error: $e\n$stackTrace");
      state = state.copyWith(isLoading: false, error: errorMsg);
    }
  }
  Future<void> registerOtpRequest(
      String url,
      Map map,
      {
        String? otp,
        String? mobile,
        bool? isFirstTime = false,
        bool? firstVerify = false,
        bool? resetPassword = false,

      }) async {
    state = state.copyWith(isOtpLoading: true, error: null, otp: otp,mobile: mobile,);

    try {
      final response = await Repo().otpRequest(url,map);
      print(response);
      if (response["status"] == 1) {
        final userData = UserLoginResponse.fromJson(response["data"]);
        await SharedPreferencesHelper().init();
        await SharedPreferencesHelper().setBool("isLoggedIn", true);
        await SharedPreferencesHelper().setString("token", userData.token);
        print(" hello:${userData.token}");
         if(isFirstTime == true && firstVerify == true){
          print("Yes here");
          Get.to(() => SetPasswordScreen(mobile: mobile.toString(),isPasswordReset:false));
        }
         else if(isFirstTime == true && firstVerify == false && resetPassword == true){
          Get.to(() => SetPasswordScreen(mobile: mobile.toString(), isPasswordReset: true));
        }else if(isFirstTime == true){
           Get.to(() => OTPVerificationScreen(mobile: mobile.toString(), isFirstTime: true));
         }

        if (userData.token.isNotEmpty) {
          Toaster.showSuccess(response['data']?["message"]);
          Get.offAllNamed(AppRoutes.home);
        }

        state = state.copyWith(
          isOtpLoading: false,
          isLoggedIn: true,
          user: userData,
        );
      } else {
        final errorMsg = response['message']?["message"] ?? 'Login failed';
        Toaster.showError(response['message']?["message"]);
        state = state.copyWith(isOtpLoading: false, error: errorMsg);
      }
    } catch (e, stackTrace) {
      final errorMsg = "Network error. Please try again.";

      print("Login error: $e\n$stackTrace");
      state = state.copyWith(isOtpLoading: false, error: errorMsg);
    }
  }

  Future<void> forgotFlowRequest(
      String url,
      Map map,
      {
        String? otp,
        String? mobile,
        bool? isPasswordReset = false,

      }) async {
    state = state.copyWith(isForgotLoading: true, error: null, otp: otp,mobile: mobile);

    try {
      final response = await Repo().otpRequest(url,map);
      print(response);
      if (response["status"] == 1) {
        final userData = UserLoginResponse.fromJson(response["data"]);
        await SharedPreferencesHelper().init();
        await SharedPreferencesHelper().setBool("isLoggedIn", true);
        await SharedPreferencesHelper().setString("token", userData.token);
        print(" hello:${userData.token}");
        if(isPasswordReset == true){
          Get.to(() => OTPVerificationScreen(mobile: mobile.toString(), isPasswordReset: true));
        }
        if (userData.token.isNotEmpty) {
          Toaster.showSuccess(userData.message);
          Get.offAllNamed(AppRoutes.home);
        }

        state = state.copyWith(
          isForgotLoading: false,
          isLoggedIn: true,
          user: userData,
        );
      } else {
        Toaster.showError(response['message']?["message"]);
        final errorMsg = response['message']?["message"] ?? 'Login failed';
        state = state.copyWith(isForgotLoading: false, error: errorMsg);
      }
    } catch (e, stackTrace) {
      final errorMsg = "Network error. Please try again.";

      print("Login error: $e\n$stackTrace");
      state = state.copyWith(isForgotLoading: false, error: errorMsg);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      final token =
          state.user?.token ??
          await SharedPreferencesHelper().getString("token");
      if (token != null && token.isNotEmpty) {
        await Repo().logOut(token);
      }

      await SharedPreferencesHelper().init();
      await SharedPreferencesHelper().clear();

      Get.offAllNamed(AppRoutes.login);

      state = const LoginState();
    } catch (e, stackTrace) {
      print("Logout error: $e\n$stackTrace");
      state = state.copyWith(isLoading: false, error: "Logout failed");
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(),
);
