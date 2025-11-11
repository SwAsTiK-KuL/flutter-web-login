import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_flags/country_flags.dart';
import '../utils/constants.dart';
import '../screens/phone_otp_screen.dart';

class FormSectionWidget extends StatefulWidget {
  const FormSectionWidget({Key? key}) : super(key: key);

  @override
  State<FormSectionWidget> createState() => _FormSectionWidgetState();
}

class _FormSectionWidgetState extends State<FormSectionWidget> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
        final bool isValid = _phoneController.text.length == 10;

        return Container(
          constraints: BoxConstraints(
            maxWidth: _getMaxFormWidth(isMobile, isTablet, containerWidth),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(isMobile, isVerySmall),
              SizedBox(height: _getTitleSpacing(isMobile)),
              _buildSubtitle(isMobile, isVerySmall),
              SizedBox(height: _getSectionSpacing(isMobile)),
              _buildMobileNumberSection(isMobile, isTablet, isVerySmall),
              SizedBox(height: _getSectionSpacing(isMobile)),
              _buildGetOtpButton(context, isValid, isMobile, isVerySmall),
              SizedBox(height: _getSmallSpacing(isMobile)),
              _buildTermsAndPrivacy(context, isMobile, isVerySmall),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(bool isMobile, bool isVerySmall) {
    return Text(
      "Let's Get You Started",
      style: TextStyle(
        fontSize: _getTitleSize(isMobile, isVerySmall),
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
        fontSize: _getSubtitleSize(isMobile, isVerySmall),
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
            fontSize: _getLabelSize(isMobile, isVerySmall),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: _getSmallSpacing(isMobile)),
        _buildPhoneInput(isMobile, isTablet, isVerySmall),
        SizedBox(height: _getSmallSpacing(isMobile)),
        Text(
          'You will receive OTP on mobile number',
          style: TextStyle(
            fontSize: _getHelperTextSize(isMobile, isVerySmall),
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput(bool isMobile, bool isTablet, bool isVerySmall) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _buildCountryCode(isMobile, isVerySmall),
          Container(
            height: _getDividerHeight(isMobile, isVerySmall),
            width: 1,
            color: AppColors.borderColor,
          ),
          Expanded(child: _buildPhoneField(isMobile, isVerySmall)),
        ],
      ),
    );
  }

  Widget _buildCountryCode(bool isMobile, bool isVerySmall) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(isMobile, isVerySmall),
        vertical: _getVerticalPadding(isMobile, isVerySmall),
      ),
      child: Row(
        children: [
          _buildIndianFlag(isVerySmall),
          SizedBox(width: _getSmallSpacing(isMobile)),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textGray,
            size: _getIconSize(isMobile, isVerySmall),
          ),
        ],
      ),
    );
  }

  Widget _buildIndianFlag(bool isVerySmall) {
    final flagSize = _getFlagSize(isVerySmall);

    return Container(
      width: flagSize.width,
      height: flagSize.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: CountryFlag.fromCountryCode('IN'),
      ),
    );
  }

  Widget _buildPhoneField(bool isMobile, bool isVerySmall) {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        hintText: '1234567890',
        hintStyle: TextStyle(
          color: AppColors.disabledText,
          fontSize: _getInputTextSize(isMobile, isVerySmall),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: _getHorizontalPadding(isMobile, isVerySmall),
          vertical: _getVerticalPadding(isMobile, isVerySmall),
        ),
        prefixText: '+91 ',
        prefixStyle: TextStyle(
          color: const Color(0xFF374151),
          fontSize: _getInputTextSize(isMobile, isVerySmall),
        ),
      ),
      style: TextStyle(
        fontSize: _getInputTextSize(isMobile, isVerySmall),
        color: const Color(0xFF374151),
      ),
    );
  }

  Widget _buildGetOtpButton(
    BuildContext context,
    bool isValid,
    bool isMobile,
    bool isVerySmall,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            isValid
                ? () {
                  print('Get OTP pressed: ${_phoneController.text}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => PhillipCapitalOTPScreen(
                            phoneNumber: _phoneController.text,
                          ),
                    ),
                  );
                }
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isValid ? AppColors.primaryOrange : AppColors.disabledBg,
          foregroundColor: isValid ? Colors.white : AppColors.disabledText,
          padding: EdgeInsets.symmetric(
            vertical: _getButtonPadding(isMobile, isVerySmall),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          'Get OTP',
          style: TextStyle(
            fontSize: _getButtonTextSize(isMobile, isVerySmall),
            fontWeight: FontWeight.w600,
            color: isValid ? Colors.white : AppColors.disabledText,
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAndPrivacy(
    BuildContext context,
    bool isMobile,
    bool isVerySmall,
  ) {
    return Wrap(
      children: [
        Text(
          'By proceeding I Accept the ',
          style: TextStyle(
            fontSize: _getTermsTextSize(isMobile, isVerySmall),
            color: AppColors.textGray,
          ),
        ),
        _linkText(
          'T&C Privacy Policy',
          'T&C Privacy Policy will open here',
          isMobile,
          isVerySmall,
        ),
        Text(
          ' & ',
          style: TextStyle(
            fontSize: _getTermsTextSize(isMobile, isVerySmall),
            color: AppColors.textGray,
          ),
        ),
        _linkText(
          'Tariff rates',
          'Tariff rates will open here',
          isMobile,
          isVerySmall,
        ),
      ],
    );
  }

  Widget _linkText(
    String text,
    String snackbarMsg,
    bool isMobile,
    bool isVerySmall,
  ) {
    return GestureDetector(
      onTap:
          () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(snackbarMsg))),
      child: Text(
        text,
        style: TextStyle(
          fontSize: _getTermsTextSize(isMobile, isVerySmall),
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

  double _getTitleSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 24;
    if (isMobile) return 28;
    return 32; // Desktop
  }

  double _getSubtitleSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 12;
    return 14; // Mobile and up
  }

  double _getLabelSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 12;
    return 14; // Mobile and up
  }

  double _getInputTextSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 14;
    return 16; // Mobile and up
  }

  double _getButtonTextSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 14;
    return 16; // Mobile and up
  }

  double _getTermsTextSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 10;
    return 12; // Mobile and up
  }

  double _getHelperTextSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 10;
    return 12; // Mobile and up
  }

  double _getIconSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 16;
    if (isMobile) return 18;
    return 20; // Desktop
  }

  Size _getFlagSize(bool isVerySmall) {
    if (isVerySmall) return const Size(16, 12);
    return const Size(20, 15); // Standard size
  }

  double _getHorizontalPadding(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 8;
    return 12; // Mobile and up
  }

  double _getVerticalPadding(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 12;
    return 16; // Mobile and up
  }

  double _getButtonPadding(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 12;
    return 16; // Mobile and up
  }

  double _getDividerHeight(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 20;
    return 24; // Mobile and up
  }

  double _getTitleSpacing(bool isMobile) {
    return isMobile ? 6 : 8;
  }

  double _getSectionSpacing(bool isMobile) {
    return isMobile ? 24 : 40;
  }

  double _getSmallSpacing(bool isMobile) {
    return isMobile ? 6 : 8;
  }
}
