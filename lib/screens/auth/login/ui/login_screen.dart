import 'package:flutter/material.dart';
import 'package:flutter_app/screens/auth/login/notifier/login_notifier.dart';
import 'package:flutter_app/services/api/notification_service/notifiction_service.dart';
import 'package:flutter_app/services/local_storage/shared_preference.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../../config/theme.dart';
import '../../otp_verification_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _mobileController = TextEditingController();
  final _passWordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? dToken;
  bool _obscurePassword = true;
  bool _validateFields = false;

  // Scenario tracker: 'continue', 'otp', or 'none'
  String _activeScenario = 'none';

  @override
  void dispose() {
    _mobileController.dispose();
    _passWordController.dispose();
    super.dispose();
  }

  // SCENARIO 1: Full Validation (Mobile + Password)
  Future<void> _handleContinue() async {
    setState(() {
      _activeScenario = 'continue';
      _validateFields = true;
    });

    if (!_formKey.currentState!.validate()) return;

    await ref.read(loginProvider.notifier).login({
      "mobile": _mobileController.text.trim(),
      "password": _passWordController.text,
      "fcm_token":dToken ?? ''
    },mobile: _mobileController.text.trim());
  }

  // SCENARIO 2: Mobile Validation Only
  Future<void> _handleFirstTimeUser() async {
    setState(() {
      _activeScenario = 'otp';
      _validateFields = true;
    });

    if (!_formKey.currentState!.validate()) return;

    final mobile = _mobileController.text.trim();
    await ref.read(loginProvider.notifier).registerOtpRequest("api/customer/send-otp", {"mobile": mobile},mobile: mobile,isFirstTime: true);

  }

  Future<void> _handleForgetUser() async {
    setState(() {
      _activeScenario = 'otp';
      _validateFields = true;
    });

    if (!_formKey.currentState!.validate()) return;

    final mobile = _mobileController.text.trim();
    await ref.read(loginProvider.notifier).forgotFlowRequest("api/customer/forgot-password-otp",
        {"mobile": mobile},mobile: mobile,isPasswordReset: true);
  }
 @override
  void initState() {
    super.initState();
   dToken =  SharedPreferencesHelper().getString("DToken");
   print("$dToken is the sharedToken");
  }
  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            // Switches to live validation after first button click
            autovalidateMode: _validateFields
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo Section
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                const Text('Welcome to', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: AppTheme.textGrey)),
                const SizedBox(height: 8),
                const Text('Shri Jalore Jain Sangh Chennai', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),

                const SizedBox(height: 48),

                // Mobile Input
                const Text('Enter your mobile number', style: TextStyle(fontSize: 16, color: AppTheme.textDark)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: _buildInputDecoration('Mobile Number', Icons.phone),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter mobile number';
                    if (value.length != 10) return 'Mobile number must be 10 digits';
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Please enter valid numbers only';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password Input
                const Text('Enter your Password', style: TextStyle(fontSize: 16, color: AppTheme.textDark)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passWordController,
                  obscureText: _obscurePassword,
                  decoration: _buildInputDecoration('Password', Icons.password).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: AppTheme.textGrey),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    // LIVE REACTIVE VALIDATION: Only checks if scenario is 'continue'
                    if (_activeScenario == 'continue') {
                      if (value == null || value.isEmpty) return 'Please enter password';
                      if (value.length < 6) return 'Password must be 6 digits above';
                    }
                    return null;
                  },
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: loginState.isLoading ? null : _handleForgetUser,
                    child: const Text('Forgot Password?', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                  ),
                ),

                const SizedBox(height: 15),

                // Continue Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loginState.isLoading ? null : _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: loginState.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                        : const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 16),

                // First Time User Button
                TextButton.icon(
                  onPressed: loginState.isLoading ? null : _handleFirstTimeUser,
                  icon: const Icon(Icons.person_add),
                  label: const Text('First Time User? Register with OTP'),
                  style: TextButton.styleFrom(foregroundColor: AppTheme.primaryBlue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper to keep code clean
  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppTheme.primaryBlue),
      counterText: '',
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
      ),
    );
  }
}