import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import '../screens/additional_details_screen.dart';

class EmailOTPSectionWidget extends StatefulWidget {
  final String email;

  const EmailOTPSectionWidget({Key? key, required this.email})
    : super(key: key);

  @override
  State<EmailOTPSectionWidget> createState() => _EmailOTPSectionWidgetState();
}

class _EmailOTPSectionWidgetState extends State<EmailOTPSectionWidget> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendTimer = 60;
  late Timer _timer;
  bool _canResend = false;
  String? _generatedOTP;

  @override
  void initState() {
    super.initState();
    _generateAndShowOTP();
    _startTimer();
  }

  void _generateAndShowOTP() {
    _generatedOTP = _generateRandomOTP();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your Email OTP: $_generatedOTP'),
          backgroundColor: AppColors.snackbarBlue,
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'Copy',
            textColor: Colors.white,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _generatedOTP!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('OTP copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  String _generateRandomOTP() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  void _startTimer() {
    _canResend = false;
    _resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _verifyOTP();
    }
  }

  void _verifyOTP() {
    final entered = _controllers.map((c) => c.text).join();
    if (entered == _generatedOTP) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully!'),
          backgroundColor: AppColors.successGreen,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PhillipCapitalAdditionalDetailsScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP. Please try again.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      for (var c in _controllers) c.clear();
      _focusNodes[0].requestFocus();
    }
  }

  void _resendOTP() {
    if (_canResend) {
      _generateAndShowOTP();
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New OTP sent to your email!'),
          backgroundColor: AppColors.successGreen,
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
          'Verify Your Email',
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
          'Email',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        _buildEmailDisplay(),
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

  Widget _buildEmailDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
        color: const Color(0xFFF9FAFB),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.email,
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

  Widget _buildResendRow() {
    final minutes = (_resendTimer ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendTimer % 60).toString().padLeft(2, '0');
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
              'Resend in $minutes:$seconds',
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _verifyOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
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
      onTap:
          () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg))),
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
