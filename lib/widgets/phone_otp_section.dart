import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:philip_capital_india/utils/constants.dart';
import 'package:philip_capital_india/screens/email_verification_screen.dart';

class OTPSectionWidget extends StatefulWidget {
  final String phoneNumber;

  const OTPSectionWidget({Key? key, required this.phoneNumber})
    : super(key: key);

  @override
  State<OTPSectionWidget> createState() => _OTPSectionWidgetState();
}

class _OTPSectionWidgetState extends State<OTPSectionWidget> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendTimer = 30;
  Timer? _timer; // Made nullable to fix LateInitializationError
  bool _canResend = false;
  String? _generatedOTP;

  @override
  void initState() {
    super.initState();
    // Generate OTP first
    _generatedOTP = _generateRandomOTP();

    // Start timer
    _startTimer();

    // Show OTP in SnackBar after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOTPSnackBar();
    });
  }

  void _showOTPSnackBar() {
    if (mounted && _generatedOTP != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Your OTP: $_generatedOTP')),
              TextButton(
                onPressed: () {
                  if (_generatedOTP != null) {
                    Clipboard.setData(ClipboardData(text: _generatedOTP!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP copied to clipboard!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Copy',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryOrange,
          duration: const Duration(seconds: 8),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _generateRandomOTP() {
    final random = Random();
    String otp = '';
    for (int i = 0; i < 6; i++) {
      otp += random.nextInt(10).toString();
    }
    return otp;
  }

  void _startTimer() {
    _canResend = false;
    _resendTimer = 30;

    // Cancel existing timer if any
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_resendTimer > 0) {
          setState(() => _resendTimer--);
        } else {
          setState(() => _canResend = true);
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Auto-verify when all fields are filled
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _verifyOTP();
    }
  }

  void _verifyOTP() {
    if (!mounted || _generatedOTP == null) return;

    final enteredOTP = _controllers.map((c) => c.text).join();

    if (enteredOTP.length == 6) {
      if (enteredOTP == _generatedOTP) {
        // OTP verification successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('OTP verified successfully!'),
              ],
            ),
            backgroundColor: AppColors.successGreen,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to email verification screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PhillipCapitalEmailScreen()),
        );
      } else {
        // OTP verification failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Invalid OTP. Please try again.'),
              ],
            ),
            backgroundColor: AppColors.errorRed,
            duration: Duration(seconds: 3),
          ),
        );

        // Clear all OTP fields
        for (var controller in _controllers) {
          controller.clear();
        }
        // Focus back to first field
        if (mounted) {
          _focusNodes[0].requestFocus();
        }
      }
    }
  }

  void _resendOTP() {
    if (_canResend && mounted) {
      // Generate new OTP
      _generatedOTP = _generateRandomOTP();

      // Show new OTP in SnackBar
      _showOTPSnackBar();

      // Restart timer
      _startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.refresh, color: Colors.white),
              SizedBox(width: 8),
              Text('New OTP sent successfully!'),
            ],
          ),
          backgroundColor: AppColors.successGreen,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter the 6-Digit Code',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'or Resume pending application',
          style: TextStyle(fontSize: 14, color: AppColors.textGray),
        ),
        const SizedBox(height: 40),
        const Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        _buildPhoneDisplay(),
        const SizedBox(height: 8),
        const Text(
          'You will receive OTP on mobile number',
          style: TextStyle(fontSize: 12, color: AppColors.textGray),
        ),
        const SizedBox(height: 32),
        _buildResendRow(),
        const SizedBox(height: 16),
        _buildOTPFields(),
        const SizedBox(height: 32),
        _buildVerifyButton(),
        const SizedBox(height: 16),
        _buildTerms(),
      ],
    );
  }

  Widget _buildPhoneDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _buildIndianFlag(),
          const SizedBox(width: 8),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textGray,
            size: 16,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '+91   ${widget.phoneNumber}',
              style: const TextStyle(fontSize: 16, color: Color(0xFF374151)),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.edit,
              color: AppColors.primaryOrange,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndianFlag() {
    return Container(
      width: 20,
      height: 15,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
      child: const Column(
        children: [
          Expanded(child: ColoredBox(color: Color(0xFFFF9933))),
          Expanded(child: ColoredBox(color: Colors.white)),
          Expanded(child: ColoredBox(color: Color(0xFF138808))),
        ],
      ),
    );
  }

  Widget _buildResendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Enter OTP',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        _canResend
            ? GestureDetector(
              onTap: _resendOTP,
              child: const Text(
                'Resend OTP',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.linkBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
            : Text(
              'Resend in 00:${_resendTimer.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 12, color: AppColors.errorRed),
            ),
      ],
    );
  }

  Widget _buildOTPFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) => _buildOTPBox(i)),
    );
  }

  Widget _buildOTPBox(int index) {
    return Container(
      width: 50,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              _controllers[index].text.isEmpty
                  ? AppColors.borderColor
                  : AppColors.borderActive,
        ),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (v) => _onChanged(v, index),
        onTap: () {
          _controllers[index].selection = TextSelection.fromPosition(
            TextPosition(offset: _controllers[index].text.length),
          );
        },
      ),
    );
  }

  Widget _buildVerifyButton() {
    final bool isComplete = _controllers.every((c) => c.text.isNotEmpty);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isComplete ? _verifyOTP : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isComplete ? AppColors.primaryOrange : AppColors.disabledBg,
          foregroundColor: isComplete ? Colors.white : AppColors.disabledText,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: const Text(
          'Verify',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildTerms() {
    return Wrap(
      children: [
        const Text(
          'By proceeding I Accept the ',
          style: TextStyle(fontSize: 12, color: AppColors.textGray),
        ),
        _link('T&C Privacy Policy', 'T&C Privacy Policy will open here'),
        const Text(
          ' & ',
          style: TextStyle(fontSize: 12, color: AppColors.textGray),
        ),
        _link('Tariff rates', 'Tariff rates will open here'),
      ],
    );
  }

  Widget _link(String text, String msg) {
    return GestureDetector(
      onTap: () {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.linkBlue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
