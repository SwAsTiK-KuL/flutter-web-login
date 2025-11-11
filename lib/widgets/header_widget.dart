import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        // Determine responsive breakpoints
        final bool isMobile = screenWidth < 768;
        final bool isTablet = screenWidth >= 768 && screenWidth < 1024;
        final bool isDesktop = screenWidth >= 1024;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(isMobile, isTablet),
            vertical: _getVerticalPadding(isMobile),
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
          ),
          child: _buildContent(
            context,
            isMobile,
            isTablet,
            isDesktop,
            screenWidth,
          ),
        );
      },
    );
  }

  double _getHorizontalPadding(bool isMobile, bool isTablet) {
    if (isMobile) return 16.0;
    if (isTablet) return 20.0;
    return 24.0; // Desktop
  }

  double _getVerticalPadding(bool isMobile) {
    return isMobile ? 12.0 : 16.0;
  }

  Widget _buildContent(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    double screenWidth,
  ) {
    if (isMobile) {
      return _buildMobileLayout(context, screenWidth);
    } else if (isTablet) {
      return _buildTabletLayout(context);
    } else {
      return _buildDesktopLayout(context);
    }
  }

  // Desktop Layout (>= 1024px)
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(false, false), // Not mobile, not compact
        _buildAssistanceButton(context, false, false),
      ],
    );
  }

  // Tablet Layout (768px - 1023px)
  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(false, true), // Not mobile, but compact
        _buildAssistanceButton(context, false, true),
      ],
    );
  }

  // Mobile Layout (< 768px)
  Widget _buildMobileLayout(BuildContext context, double screenWidth) {
    // For very small screens, stack vertically or use minimal layout
    if (screenWidth < 400) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLogo(true, true), // Mobile and compact
              _buildAssistanceButton(context, true, true),
            ],
          ),
        ],
      );
    }

    // Standard mobile horizontal layout
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(true, false), // Mobile but not compact
        _buildAssistanceButton(context, true, false),
      ],
    );
  }

  Widget _buildLogo(bool isMobile, bool isCompact) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'PhillipCapital',
          style: TextStyle(
            fontSize: _getLogoTextSize(isMobile, isCompact),
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildAssistanceButton(
    BuildContext context,
    bool isMobile,
    bool isCompact,
  ) {
    // Hide assistance button on very small screens
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 350) {
          return IconButton(
            onPressed: () => _showAssistanceSnackBar(context),
            icon: Icon(
              Icons.help_outline,
              color: AppColors.textGray,
              size: isMobile ? 20 : 24,
            ),
            tooltip: 'Need Assistance?',
            padding: EdgeInsets.all(isMobile ? 4 : 8),
          );
        }

        return TextButton(
          onPressed: () => _showAssistanceSnackBar(context),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 12,
              vertical: isMobile ? 4 : 8,
            ),
          ),
          child: Text(
            _getAssistanceButtonText(isMobile, isCompact),
            style: TextStyle(
              color: AppColors.textGray,
              fontSize: _getAssistanceButtonSize(isMobile, isCompact),
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
  }

  void _showAssistanceSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Assistance feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Responsive sizing methods
  double _getLogoIconSize(bool isMobile, bool isCompact) {
    if (isMobile && isCompact) return 14;
    if (isMobile) return 16;
    if (isCompact) return 16;
    return 18; // Desktop
  }

  double _getLogoTextSize(bool isMobile, bool isCompact) {
    if (isMobile && isCompact) return 18;
    if (isMobile) return 20;
    if (isCompact) return 22;
    return 24; // Desktop
  }

  String _getAssistanceButtonText(bool isMobile, bool isCompact) {
    if (isMobile && isCompact) return 'Help?';
    if (isMobile) return 'Assistance?';
    return 'Need Assistance?'; // Tablet and Desktop
  }

  double _getAssistanceButtonSize(bool isMobile, bool isCompact) {
    if (isMobile && isCompact) return 11;
    if (isMobile) return 12;
    if (isCompact) return 13;
    return 14; // Desktop
  }
}
