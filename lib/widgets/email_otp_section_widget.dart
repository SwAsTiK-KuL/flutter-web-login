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
  Timer? _timer;
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.email, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Your Email OTP: $_generatedOTP')),
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _generatedOTP!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    'Copy',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.snackbarBlue,
            duration: const Duration(seconds: 8),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  String _generateRandomOTP() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  void _startTimer() {
    _canResend = false;
    _resendTimer = 60;
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
    if (!mounted || _generatedOTP == null) return;

    final entered = _controllers.map((c) => c.text).join();
    if (entered == _generatedOTP) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Email verified successfully!'),
            ],
          ),
          backgroundColor: AppColors.successGreen,
          duration: Duration(seconds: 2),
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
      for (var c in _controllers) c.clear();
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    }
  }

  void _resendOTP() {
    if (_canResend && mounted) {
      _generateAndShowOTP();
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.refresh, color: Colors.white),
              SizedBox(width: 8),
              Text('New OTP sent to your email!'),
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
        final containerWidth = constraints.maxWidth;

        // Determine device type
        final bool isMobile = screenWidth < 768;
        final bool isTablet = screenWidth >= 768 && screenWidth < 1024;
        final bool isVerySmall = screenWidth < 400;
        final bool isUltraSmall = screenWidth < 350;

        return Container(
          constraints: BoxConstraints(
            maxWidth: _getMaxFormWidth(isMobile, isTablet, containerWidth),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(isMobile, isVerySmall, isUltraSmall),
              SizedBox(height: _getTitleSpacing(isMobile)),
              _buildSubtitle(isMobile, isVerySmall, isUltraSmall),
              SizedBox(height: _getSectionSpacing(isMobile, isVerySmall)),
              _buildEmailSection(isMobile, isTablet, isVerySmall, isUltraSmall),
              SizedBox(height: _getSectionSpacing(isMobile, isVerySmall)),
              _buildResendRow(isMobile, isTablet, isVerySmall),
              SizedBox(height: _getSmallSpacing(isMobile)),
              _buildOTPFields(isMobile, isTablet, isVerySmall, isUltraSmall),
              SizedBox(height: _getSectionSpacing(isMobile, isVerySmall)),
              _buildVerifyButton(isMobile, isVerySmall),
              SizedBox(height: _getSmallSpacing(isMobile)),
              _buildTerms(isMobile, isVerySmall, isUltraSmall),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    return Text(
      'Verify Your Email',
      style: TextStyle(
        fontSize: _getTitleFontSize(isMobile, isVerySmall, isUltraSmall),
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    return Text(
      'or Resume pending application',
      style: TextStyle(
        fontSize: _getSubtitleFontSize(isMobile, isVerySmall, isUltraSmall),
        color: AppColors.textGray,
      ),
    );
  }

  Widget _buildEmailSection(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            fontSize: _getLabelFontSize(isMobile, isVerySmall, isUltraSmall),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: _getSmallSpacing(isMobile)),
        _buildEmailDisplay(isMobile, isTablet, isVerySmall, isUltraSmall),
        SizedBox(height: _getSmallSpacing(isMobile)),
        Text(
          'You will receive OTP on email address',
          style: TextStyle(
            fontSize: _getHelperTextFontSize(
              isMobile,
              isVerySmall,
              isUltraSmall,
            ),
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailDisplay(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getEmailPaddingHorizontal(isMobile, isVerySmall),
        vertical: _getEmailPaddingVertical(isMobile, isVerySmall),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          _getBorderRadius(isMobile, isVerySmall),
        ),
        border: Border.all(color: AppColors.borderColor),
        color: const Color(0xFFF9FAFB),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.email,
              style: TextStyle(
                fontSize: _getEmailFontSize(
                  isMobile,
                  isVerySmall,
                  isUltraSmall,
                ),
                color: const Color(0xFF374151),
              ),
              overflow: isUltraSmall ? TextOverflow.ellipsis : null,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.edit,
              color: AppColors.primaryOrange,
              size: _getEditIconSize(isMobile, isVerySmall),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResendRow(bool isMobile, bool isTablet, bool isVerySmall) {
    final minutes = (_resendTimer ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendTimer % 60).toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Enter OTP',
          style: TextStyle(
            fontSize: _getLabelFontSize(isMobile, isVerySmall, false),
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
                  fontSize: _getResendFontSize(isMobile, isVerySmall),
                  color: AppColors.linkBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
            : Text(
              'Resend in $minutes:$seconds',
              style: TextStyle(
                fontSize: _getResendFontSize(isMobile, isVerySmall),
                color: AppColors.errorRed,
              ),
            ),
      ],
    );
  }

  Widget _buildOTPFields(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (i) => _buildOTPBox(i, isMobile, isVerySmall, isUltraSmall),
      ),
    );
  }

  Widget _buildOTPBox(
    int index,
    bool isMobile,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    final boxSize = _getOTPBoxSize(isMobile, isVerySmall, isUltraSmall);

    return Container(
      width: boxSize.width,
      height: boxSize.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          _getBorderRadius(isMobile, isVerySmall),
        ),
        border: Border.all(
          color:
              _controllers[index].text.isEmpty
                  ? AppColors.borderColor
                  : AppColors.borderActive,
          width: _controllers[index].text.isEmpty ? 1 : 1.5,
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
          fontSize: _getOTPTextSize(isMobile, isVerySmall, isUltraSmall),
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

  Widget _buildVerifyButton(bool isMobile, bool isVerySmall) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _verifyOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: _getButtonPadding(isMobile, isVerySmall),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              _getBorderRadius(isMobile, isVerySmall),
            ),
          ),
          elevation: 0,
        ),
        child: Text(
          'Verify',
          style: TextStyle(
            fontSize: _getButtonFontSize(isMobile, isVerySmall),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTerms(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    return Wrap(
      children: [
        Text(
          'By proceeding I Accept the ',
          style: TextStyle(
            fontSize: _getTermsFontSize(isMobile, isVerySmall, isUltraSmall),
            color: AppColors.textGray,
          ),
        ),
        _link(
          'T&C Privacy Policy',
          'T&C Privacy Policy will open here',
          isMobile,
          isVerySmall,
          isUltraSmall,
        ),
        Text(
          ' & ',
          style: TextStyle(
            fontSize: _getTermsFontSize(isMobile, isVerySmall, isUltraSmall),
            color: AppColors.textGray,
          ),
        ),
        _link(
          'Tariff rates',
          'Tariff rates will open here',
          isMobile,
          isVerySmall,
          isUltraSmall,
        ),
      ],
    );
  }

  Widget _link(
    String text,
    String msg,
    bool isMobile,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    return GestureDetector(
      onTap:
          () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg))),
      child: Text(
        text,
        style: TextStyle(
          fontSize: _getTermsFontSize(isMobile, isVerySmall, isUltraSmall),
          color: AppColors.linkBlue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // Responsive sizing methods
  double _getMaxFormWidth(bool isMobile, bool isTablet, double containerWidth) {
    if (isMobile) return containerWidth;
    if (isTablet) return containerWidth * 0.9;
    return 500; // Desktop max width
  }

  double _getTitleFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 24;
    if (isVerySmall) return 28;
    if (isMobile) return 30;
    return 32; // Desktop
  }

  double _getSubtitleFontSize(
    bool isMobile,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    if (isUltraSmall) return 12;
    return 14; // Standard
  }

  double _getLabelFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 12;
    if (isVerySmall) return 13;
    return 14; // Standard
  }

  double _getEmailFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 13;
    if (isVerySmall) return 14;
    return 16; // Standard
  }

  double _getResendFontSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 11;
    return 12; // Standard
  }

  double _getOTPTextSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 16;
    if (isVerySmall) return 18;
    return 20; // Standard
  }

  double _getButtonFontSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 14;
    return 16; // Standard
  }

  double _getTermsFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 10;
    return 12; // Standard
  }

  double _getHelperTextFontSize(
    bool isMobile,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    if (isUltraSmall) return 10;
    if (isVerySmall) return 11;
    return 12; // Standard
  }

  double _getEditIconSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 18;
    return 20; // Standard
  }

  Size _getOTPBoxSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return const Size(36, 44);
    if (isVerySmall) return const Size(42, 50);
    if (isMobile) return const Size(46, 54);
    return const Size(50, 56); // Desktop
  }

  double _getBorderRadius(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 6;
    return 8; // Standard
  }

  double _getTitleSpacing(bool isMobile) {
    return isMobile ? 6 : 8;
  }

  double _getSectionSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 20;
    if (isMobile) return 24;
    return 32; // Desktop
  }

  double _getSmallSpacing(bool isMobile) {
    return isMobile ? 12 : 16;
  }

  double _getEmailPaddingHorizontal(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 12;
    return 16; // Standard
  }

  double _getEmailPaddingVertical(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 12;
    return 16; // Standard
  }

  double _getButtonPadding(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 12;
    return 16; // Standard
  }
}
