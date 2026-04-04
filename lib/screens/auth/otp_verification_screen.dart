import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/auth/login/notifier/login_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPVerificationScreen extends ConsumerStatefulWidget {
  final String mobile;
  final bool isFirstTime;
  final bool isPasswordReset;

  const OTPVerificationScreen({
    super.key,
    required this.mobile,
    this.isFirstTime = false,
    this.isPasswordReset = false,
  });

  @override
  ConsumerState<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _isResending = false;
  Timer? _otpTimer;
  int _secondsRemaining = 60;


  @override
  void dispose() {
    _otpTimer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otp {
    return _otpControllers.map((c) => c.text).join();
  }

  Future<void> _verifyOTP() async {
    if (_otp.length != 6) {
      _showError('Please enter complete OTP');
      return;
    }



        if (widget.isFirstTime) {
          print("entry 1");
          await ref.read(loginProvider.notifier).registerOtpRequest("api/customer/verify-otp", {
            "otp": _otp,
            "mobile": widget.mobile,
          },otp: _otp.toString(),
              mobile: widget.mobile,
              isFirstTime: true,
            firstVerify:true
          );
        } else if (widget.isPasswordReset) {
          await ref.read(loginProvider.notifier).registerOtpRequest("api/customer/verify-otp", {
            "otp": _otp,
            "mobile": widget.mobile,
          },otp: _otp.toString(),isFirstTime: true,
              mobile: widget.mobile,
              firstVerify:false,
            resetPassword: true
          );
        }

  }

  Future<void> _resendOTP() async {
    if (_isResending) return;

    await ref.read(loginProvider.notifier).registerOtpRequest(
      "api/customer/send-otp",
      {"mobile": widget.mobile},
    );

    _startOtpTimer(); // 🔥 restart 1-min timer
  }



  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startOtpTimer();
  }
  void _startOtpTimer() {
    _otpTimer?.cancel();
    setState(() {
      _secondsRemaining = 60;
      _isResending = true;
    });

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResending = false;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.read(loginProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E90FF)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[50],
                ),
                child: const Icon(
                  Icons.message,
                  size: 40,
                  color: Color(0xFF1E90FF),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'OTP Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E90FF),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Enter the 6-digit code sent to\n${widget.mobile}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A3B3B),
                ),
              ),

              const SizedBox(height: 48),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 60,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      obscureText: false,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Explicitly set color
                      ),
                      // This prevents the "i" or "dot" visual glitch on some devices
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.grey[100],
                        // Ensure content padding doesn't push text out of view
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF1E90FF),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }

                        if (index == 5 && value.isNotEmpty) {
                          _verifyOTP();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Verify Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed:state.isOtpLoading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E90FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: state.isOtpLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isResending
                        ? 'Resend OTP in 00:${_secondsRemaining.toString().padLeft(2, '0')}'
                        : "Didn't receive OTP? ",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A3B3B),
                    ),
                  ),
                  if (!_isResending)
                    TextButton(
                      onPressed: _resendOTP,
                      child: const Text(
                        'Resend',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E90FF),
                        ),
                      ),
                    ),
                ],
              ),


              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
