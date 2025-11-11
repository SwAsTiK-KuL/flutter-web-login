import 'package:flutter/material.dart';
import 'package:philip_capital_india/utils/constants.dart';
import 'package:philip_capital_india/screens/email_otp_screen.dart';

class EmailSectionWidget extends StatefulWidget {
  const EmailSectionWidget({super.key});

  @override
  State<EmailSectionWidget> createState() => _EmailSectionWidgetState();
}

class _EmailSectionWidgetState extends State<EmailSectionWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isValid = _isValidEmail(_controller.text);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _getOTP() {
    if (_isValid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PhillipCapitalEmailOTPScreen(email: _controller.text),
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

        final bool hasText = _controller.text.isNotEmpty;
        final Color borderColor = _getBorderColor(hasText);

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
              _buildEmailSection(
                isMobile,
                isTablet,
                isVerySmall,
                isUltraSmall,
                borderColor,
              ),
              SizedBox(height: _getSectionSpacing(isMobile, isVerySmall)),
              _buildGetOtpButton(isMobile, isVerySmall),
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
      'Enter Your Email',
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
    Color borderColor,
  ) {
    final bool hasText = _controller.text.isNotEmpty;

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
        _buildEmailInput(
          isMobile,
          isTablet,
          isVerySmall,
          isUltraSmall,
          borderColor,
        ),
        SizedBox(height: _getSmallSpacing(isMobile)),
        _buildValidationMessage(isMobile, isVerySmall, isUltraSmall, hasText),
      ],
    );
  }

  Widget _buildEmailInput(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    bool isUltraSmall,
    Color borderColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          _getBorderRadius(isMobile, isVerySmall),
        ),
        border: Border.all(
          color: borderColor,
          width: _getBorderWidth(isMobile, _controller.text.isNotEmpty),
        ),
        color: Colors.white,
        boxShadow:
            !isMobile && _controller.text.isNotEmpty
                ? [
                  BoxShadow(
                    color: (_isValid
                            ? AppColors.successGreen
                            : AppColors.errorRed)
                        .withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: _getHintText(isMobile, isVerySmall),
          hintStyle: TextStyle(
            color: AppColors.disabledText,
            fontSize: _getInputFontSize(isMobile, isVerySmall, isUltraSmall),
          ),
          border: InputBorder.none,
          contentPadding: _getInputPadding(isMobile, isTablet, isVerySmall),
          suffixIcon:
              _controller.text.isNotEmpty
                  ? Container(
                    margin: EdgeInsets.all(isVerySmall ? 8 : 12),
                    child: Icon(
                      _isValid ? Icons.check_circle : Icons.error,
                      color:
                          _isValid
                              ? AppColors.successGreen
                              : AppColors.errorRed,
                      size: _getValidationIconSize(isMobile, isVerySmall),
                    ),
                  )
                  : null,
        ),
        style: TextStyle(
          fontSize: _getInputFontSize(isMobile, isVerySmall, isUltraSmall),
          color: const Color(0xFF374151),
          height: _getInputLineHeight(isMobile),
        ),
      ),
    );
  }

  Widget _buildValidationMessage(
    bool isMobile,
    bool isVerySmall,
    bool isUltraSmall,
    bool hasText,
  ) {
    if (hasText && !_isValid) {
      return Row(
        children: [
          Icon(
            Icons.error_outline,
            size: _getMessageIconSize(isMobile, isVerySmall),
            color: AppColors.errorRed,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Please enter a valid email address',
              style: TextStyle(
                fontSize: _getMessageFontSize(
                  isMobile,
                  isVerySmall,
                  isUltraSmall,
                ),
                color: AppColors.errorRed,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: _getMessageIconSize(isMobile, isVerySmall),
          color: AppColors.textGray,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'You will receive OTP on email address',
            style: TextStyle(
              fontSize: _getMessageFontSize(
                isMobile,
                isVerySmall,
                isUltraSmall,
              ),
              color: AppColors.textGray,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGetOtpButton(bool isMobile, bool isVerySmall) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isValid ? _getOTP : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isValid ? AppColors.primaryOrange : AppColors.disabledBg,
          foregroundColor: _isValid ? Colors.white : AppColors.disabledText,
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
          'Get OTP',
          style: TextStyle(
            fontSize: _getButtonFontSize(isMobile, isVerySmall),
            fontWeight: FontWeight.w600,
            color: _isValid ? Colors.white : AppColors.disabledText,
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

  // Helper methods
  Color _getBorderColor(bool hasText) {
    if (!hasText) return AppColors.borderColor;
    return _isValid ? AppColors.borderValid : AppColors.borderError;
  }

  String _getHintText(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 'your@email.com';
    return 'suhani@joshigmail.com';
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

  double _getInputFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 14;
    if (isVerySmall) return 15;
    return 16; // Standard
  }

  double _getButtonFontSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 14;
    return 16; // Standard
  }

  double _getMessageFontSize(
    bool isMobile,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    if (isUltraSmall) return 10;
    if (isVerySmall) return 11;
    return 12; // Standard
  }

  double _getTermsFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 10;
    return 12; // Standard
  }

  double _getValidationIconSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 18;
    return 20; // Standard
  }

  double _getMessageIconSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 14;
    return 16; // Standard
  }

  double _getBorderRadius(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 6;
    return 8; // Standard
  }

  double _getBorderWidth(bool isMobile, bool hasText) {
    if (hasText) return 1.5;
    return 1; // Standard
  }

  double _getInputLineHeight(bool isMobile) {
    return isMobile ? 1.4 : 1.5;
  }

  double _getTitleSpacing(bool isMobile) {
    return isMobile ? 6 : 8;
  }

  double _getSectionSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 24;
    if (isMobile) return 32;
    return 40; // Desktop
  }

  double _getSmallSpacing(bool isMobile) {
    return isMobile ? 6 : 8;
  }

  double _getButtonPadding(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 12;
    return 16; // Standard
  }

  EdgeInsets _getInputPadding(bool isMobile, bool isTablet, bool isVerySmall) {
    final horizontal = isVerySmall ? 12.0 : 16.0;
    final vertical = isVerySmall ? 12.0 : 16.0;

    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }
}
