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
    final bool isValid = _phoneController.text.length == 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Let's Get You Started",
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
        _buildPhoneInput(),
        const SizedBox(height: 8),
        const Text(
          'You will receive OTP on mobile number',
          style: TextStyle(fontSize: 12, color: AppColors.textGray),
        ),
        const SizedBox(height: 32),
        _buildGetOtpButton(context, isValid),
        const SizedBox(height: 16),
        _buildTermsAndPrivacy(context),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _buildCountryCode(),
          Container(height: 24, width: 1, color: AppColors.borderColor),
          Expanded(child: _buildPhoneField()),
        ],
      ),
    );
  }

  Widget _buildCountryCode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          _buildIndianFlag(),
          const SizedBox(width: 8),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textGray,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildIndianFlag() {
    return Container(
      width: 20,
      height: 15,
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

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: const InputDecoration(
        hintText: '1234567890',
        hintStyle: TextStyle(color: AppColors.disabledText, fontSize: 16),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        prefixText: '+91 ',
        prefixStyle: TextStyle(color: Color(0xFF374151), fontSize: 16),
      ),
      style: const TextStyle(fontSize: 16, color: Color(0xFF374151)),
    );
  }

  Widget _buildGetOtpButton(BuildContext context, bool isValid) {
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          'Get OTP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isValid ? Colors.white : AppColors.disabledText,
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAndPrivacy(BuildContext context) {
    return Wrap(
      children: [
        const Text(
          'By proceeding I Accept the ',
          style: TextStyle(fontSize: 12, color: AppColors.textGray),
        ),
        _linkText('T&C Privacy Policy', 'T&C Privacy Policy will open here'),
        const Text(
          ' & ',
          style: TextStyle(fontSize: 12, color: AppColors.textGray),
        ),
        _linkText('Tariff rates', 'Tariff rates will open here'),
      ],
    );
  }

  Widget _linkText(String text, String snackbarMsg) {
    return GestureDetector(
      onTap:
          () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(snackbarMsg))),
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
