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
  Timer? _timer;
  bool _canResend = false;
  String? _generatedOTP;

  @override
  void initState() {
    super.initState();
    _generatedOTP = _generateRandomOTP();
    _startTimer();
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

    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _verifyOTP();
    }
  }

  void _verifyOTP() {
    if (!mounted || _generatedOTP == null) return;

    final enteredOTP = _controllers.map((c) => c.text).join();

    if (enteredOTP.length == 6) {
      if (enteredOTP == _generatedOTP) {
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

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PhillipCapitalEmailScreen()),
        );
      } else {
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

        for (var controller in _controllers) {
          controller.clear();
        }
        if (mounted) {
          _focusNodes[0].requestFocus();
        }
      }
    }
  }

  void _resendOTP() {
    if (_canResend && mounted) {
      _generatedOTP = _generateRandomOTP();
      _showOTPSnackBar();
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;
        final isTablet = screenWidth >= 768 && screenWidth < 1024;
        final isVerySmall = screenWidth < 400;

        return Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 500,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(isMobile, isVerySmall),
              SizedBox(height: isMobile ? 6 : 8),
              _buildSubtitle(isMobile, isVerySmall),
              SizedBox(height: isMobile ? 24 : 40),
              _buildMobileNumberSection(isMobile, isTablet, isVerySmall),
              SizedBox(height: isMobile ? 20 : 32),
              _buildResendRow(isMobile, isTablet),
              SizedBox(height: isMobile ? 12 : 16),
              _buildOTPFields(isMobile, isTablet, isVerySmall),
              SizedBox(height: isMobile ? 20 : 32),
              _buildVerifyButton(isMobile),
              SizedBox(height: isMobile ? 12 : 16),
              _buildTerms(isMobile, isVerySmall),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(bool isMobile, bool isVerySmall) {
    return Text(
      'Enter the 6-Digit Code',
      style: TextStyle(
        fontSize:
            isVerySmall
                ? 24
                : isMobile
                ? 28
                : 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle(bool isMobile, bool isVerySmall) {
    return Text(
      'or Resume pending application',
      style: TextStyle(
        fontSize: isVerySmall ? 12 : 14,
        color: AppColors.textGray,
      ),
    );
  }

  Widget _buildMobileNumberSection(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: isVerySmall ? 12 : 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: isMobile ? 6 : 8),
        _buildPhoneDisplay(isMobile, isTablet, isVerySmall),
        SizedBox(height: isMobile ? 6 : 8),
        Text(
          'You will receive OTP on mobile number',
          style: TextStyle(
            fontSize: isVerySmall ? 10 : 12,
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneDisplay(bool isMobile, bool isTablet, bool isVerySmall) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isVerySmall ? 12 : 16,
        vertical: isVerySmall ? 12 : 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _buildIndianFlag(isVerySmall),
          SizedBox(width: isVerySmall ? 6 : 8),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textGray,
            size: isVerySmall ? 14 : 16,
          ),
          SizedBox(width: isVerySmall ? 8 : 12),
          Expanded(
            child: Text(
              '+91   ${widget.phoneNumber}',
              style: TextStyle(
                fontSize: isVerySmall ? 14 : 16,
                color: const Color(0xFF374151),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.edit,
              color: AppColors.primaryOrange,
              size: isVerySmall ? 18 : 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndianFlag(bool isVerySmall) {
    return Container(
      width: isVerySmall ? 16 : 20,
      height: isVerySmall ? 12 : 15,
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

  Widget _buildResendRow(bool isMobile, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Enter OTP',
          style: TextStyle(
            fontSize: isMobile ? 13 : 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        _canResend
            ? GestureDetector(
              onTap: _resendOTP,
              child: Text(
                'Resend OTP',
                style: TextStyle(
                  fontSize: isMobile ? 11 : 12,
                  color: AppColors.linkBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
            : Text(
              'Resend in 00:${_resendTimer.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: isMobile ? 11 : 12,
                color: AppColors.errorRed,
              ),
            ),
      ],
    );
  }

  Widget _buildOTPFields(bool isMobile, bool isTablet, bool isVerySmall) {
    final double boxWidth =
        isVerySmall
            ? 40
            : isMobile
            ? 45
            : 50;
    final double boxHeight =
        isVerySmall
            ? 48
            : isMobile
            ? 52
            : 56;
    final double spacing =
        isVerySmall
            ? 6
            : isMobile
            ? 8
            : 12;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (i) => _buildOTPBox(i, boxWidth, boxHeight, isMobile, isVerySmall),
      ),
    );
  }

  Widget _buildOTPBox(
    int index,
    double width,
    double height,
    bool isMobile,
    bool isVerySmall,
  ) {
    return Container(
      width: width,
      height: height,
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
        style: TextStyle(
          fontSize:
              isVerySmall
                  ? 16
                  : isMobile
                  ? 18
                  : 20,
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

  Widget _buildVerifyButton(bool isMobile) {
    final bool isComplete = _controllers.every((c) => c.text.isNotEmpty);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isComplete ? _verifyOTP : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isComplete ? AppColors.primaryOrange : AppColors.disabledBg,
          foregroundColor: isComplete ? Colors.white : AppColors.disabledText,
          padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          'Verify',
          style: TextStyle(
            fontSize: isMobile ? 15 : 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTerms(bool isMobile, bool isVerySmall) {
    return Wrap(
      children: [
        Text(
          'By proceeding I Accept the ',
          style: TextStyle(
            fontSize: isVerySmall ? 10 : 12,
            color: AppColors.textGray,
          ),
        ),
        _link(
          'T&C Privacy Policy',
          'T&C Privacy Policy will open here',
          isMobile,
          isVerySmall,
        ),
        Text(
          ' & ',
          style: TextStyle(
            fontSize: isVerySmall ? 10 : 12,
            color: AppColors.textGray,
          ),
        ),
        _link(
          'Tariff rates',
          'Tariff rates will open here',
          isMobile,
          isVerySmall,
        ),
      ],
    );
  }

  Widget _link(String text, String msg, bool isMobile, bool isVerySmall) {
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
        style: TextStyle(
          fontSize: isVerySmall ? 10 : 12,
          color: AppColors.linkBlue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
