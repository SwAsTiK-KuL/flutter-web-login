import 'package:flutter/material.dart';
import '../utils/constants.dart';

class OnboardingHeaderWidget extends StatelessWidget {
  const OnboardingHeaderWidget({Key? key}) : super(key: key);

  // Helper to decide if we are on a compact screen (mobile)
  static bool _isCompact(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = _isCompact(context);
        final double horizontalPadding = isCompact ? 16.0 : 24.0;
        final double verticalPadding = isCompact ? 12.0 : 16.0;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ----- Logo / Brand -----
              Text(
                'PhillipCapital',
                style: TextStyle(
                  fontSize: isCompact ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),

              // ----- Assistance Button (hidden on very small screens) -----
              if (!isCompact || constraints.maxWidth > 400)
                TextButton(
                  onPressed:
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Assistance feature coming soon!'),
                        ),
                      ),
                  child: Text(
                    'Need Assistance?',
                    style: TextStyle(
                      color: AppColors.textGray,
                      fontSize: isCompact ? 13 : 14,
                    ),
                  ),
                )
              else
                // Optional: show an icon button on tiny screens
                IconButton(
                  icon: const Icon(
                    Icons.help_outline,
                    color: AppColors.textGray,
                    size: 20,
                  ),
                  tooltip: 'Assistance',
                  onPressed:
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Assistance feature coming soon!'),
                        ),
                      ),
                ),
            ],
          ),
        );
      },
    );
  }
}
