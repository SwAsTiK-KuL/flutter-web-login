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
    final bool hasText = _controller.text.isNotEmpty;
    final Color borderColor =
        hasText
            ? (_isValid ? AppColors.borderValid : AppColors.borderError)
            : AppColors.borderColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter Your Email',
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
        _buildEmailInput(borderColor),
        const SizedBox(height: 8),
        _buildValidationMessage(hasText),
        const SizedBox(height: 32),
        _buildGetOtpButton(),
        const SizedBox(height: 16),
        _buildTerms(),
      ],
    );
  }

  Widget _buildEmailInput(Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'suhani@joshigmail.com',
          hintStyle: const TextStyle(
            color: AppColors.disabledText,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon:
              _controller.text.isNotEmpty
                  ? Icon(
                    _isValid ? Icons.check_circle : Icons.error,
                    color:
                        _isValid ? AppColors.successGreen : AppColors.errorRed,
                    size: 20,
                  )
                  : null,
        ),
        style: const TextStyle(fontSize: 16, color: Color(0xFF374151)),
      ),
    );
  }

  Widget _buildValidationMessage(bool hasText) {
    if (hasText && !_isValid) {
      return const Text(
        'Please enter a valid email address',
        style: TextStyle(fontSize: 12, color: AppColors.errorRed),
      );
    }
    return const Text(
      'You will receive OTP on mobile number',
      style: TextStyle(fontSize: 12, color: AppColors.textGray),
    );
  }

  Widget _buildGetOtpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isValid ? _getOTP : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isValid ? AppColors.primaryOrange : AppColors.disabledBg,
          foregroundColor: _isValid ? Colors.white : AppColors.disabledText,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          'Get OTP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _isValid ? Colors.white : AppColors.disabledText,
          ),
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
