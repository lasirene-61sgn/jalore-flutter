import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/splash/riverpod/splash_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animation for the static splash logo
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashNotifierProvider);

    // Listen to route transition state changes to perform navigation
    ref.listen<SplashState>(splashNotifierProvider, (previous, next) {
      if (!next.isLoading && next.nextRoute != null) {
        Get.offAllNamed(next.nextRoute!);
      }
    });

    final bool showDynamicSplash = state.currentImageIndex >= 0 && state.images.isNotEmpty;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: showDynamicSplash
            ? CachedNetworkImage(
                key: ValueKey(state.images[state.currentImageIndex].url),
                imageUrl: state.images[state.currentImageIndex].url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Stack(
                  children: [
                    _buildStaticSplash(),
                    const Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                errorWidget: (context, url, error) => _buildStaticSplash(),
              )
            : _buildStaticSplash(),
      ),
    );
  }

  Widget _buildStaticSplash() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4DA6FF), // Light DodgerBlue
            Color(0xFF1E90FF), // DodgerBlue (from logo)
            Color(0xFF1873CC), // Dark DodgerBlue
          ],
        ),
      ),
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF8C00), // DarkOrange from logo
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // App Name
              const Text(
                'SJJSC',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
              
              const SizedBox(height: 12),
              
              const Text(
                'Shri Jalore Jain Sangh Chennai',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
