import 'package:flutter_app/screens/auth/login/ui/login_screen.dart';
import 'package:flutter_app/screens/auth/otp_verification_screen.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/splash_screen.dart';
import 'package:flutter_app/services/routes/route_name/route_name.dart';
import 'package:get/get.dart';
class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OTPVerificationScreen(mobile: '',),
    ),
  ];
}
