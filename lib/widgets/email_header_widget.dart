import 'package:flutter/material.dart';
import '../utils/constants.dart';

class OnboardingHeaderWidget extends StatelessWidget {
  const OnboardingHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'PhillipCapital',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          TextButton(
            onPressed:
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Assistance feature coming soon!'),
                  ),
                ),
            child: const Text(
              'Need Assistance?',
              style: TextStyle(color: AppColors.textGray, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
