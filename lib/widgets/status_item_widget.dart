import 'package:flutter/material.dart';

class StatusItemWidget extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final IconData icon;
  final bool isLast;

  const StatusItemWidget({
    Key? key,
    required this.title,
    required this.date,
    required this.status,
    required this.icon,
    required this.isLast,
  }) : super(key: key);

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
            maxWidth: _getMaxItemWidth(isMobile, isTablet, containerWidth),
          ),
          child: Column(
            children: [
              _buildStatusRow(isMobile, isTablet, isVerySmall, isUltraSmall),
              if (!isLast)
                SizedBox(height: _getItemSpacing(isMobile, isVerySmall)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusRow(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon Column with responsive sizing
        SizedBox(
          width: _getIconColumnWidth(isMobile, isVerySmall),
          child: _buildIconColumn(
            isMobile,
            isTablet,
            isVerySmall,
            isUltraSmall,
          ),
        ),

        SizedBox(width: _getHorizontalSpacing(isMobile, isVerySmall)),

        // Status Details with responsive layout
        Expanded(
          child: _buildStatusDetails(
            isMobile,
            isTablet,
            isVerySmall,
            isUltraSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildIconColumn(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    final statusColors = _getStatusColors();
    final bool isPending = status == 'pending';
    final bool isCompleted = status == 'completed';

    return Column(
      children: [
        // Status Icon with responsive sizing
        Container(
          width: _getIconSize(isMobile, isVerySmall),
          height: _getIconSize(isMobile, isVerySmall),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: statusColors.backgroundColor,
            border:
                isPending
                    ? Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: _getBorderWidth(isMobile, isVerySmall),
                    )
                    : null,
            boxShadow:
                !isPending && !isUltraSmall
                    ? [
                      BoxShadow(
                        color: statusColors.backgroundColor.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : null,
          ),
          child: Icon(
            icon,
            color: isPending ? const Color(0xFF9CA3AF) : Colors.white,
            size: _getIconInnerSize(isMobile, isVerySmall),
          ),
        ),

        // Vertical line below icon (responsive)
        if (!isLast)
          Container(
            width: _getLineWidth(isMobile, isVerySmall),
            height: _getLineHeight(isMobile, isVerySmall),
            margin: EdgeInsets.only(top: _getLineMargin(isMobile, isVerySmall)),
            decoration: BoxDecoration(
              color:
                  isCompleted
                      ? const Color(0xFF10B981)
                      : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusDetails(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    final statusColors = _getStatusColors();
    final bool isPending = status == 'pending';

    return Padding(
      padding: EdgeInsets.only(
        top: _getDetailsTopPadding(isMobile, isVerySmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with responsive typography
          Text(
            title,
            style: TextStyle(
              fontSize: _getTitleFontSize(isMobile, isVerySmall, isUltraSmall),
              fontWeight: FontWeight.w600,
              color:
                  isPending ? const Color(0xFF9CA3AF) : const Color(0xFF111827),
              height: _getTitleLineHeight(isMobile),
            ),
            maxLines: isUltraSmall ? 2 : null,
            overflow: isUltraSmall ? TextOverflow.ellipsis : null,
          ),

          SizedBox(height: _getTitleDateSpacing(isMobile, isVerySmall)),

          // Date with responsive styling
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: _getDatePaddingHorizontal(isMobile, isVerySmall),
              vertical: _getDatePaddingVertical(isMobile, isVerySmall),
            ),
            decoration: BoxDecoration(
              color: statusColors.textColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                _getDateBorderRadius(isMobile, isVerySmall),
              ),
              border: Border.all(
                color: statusColors.textColor.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Text(
              date,
              style: TextStyle(
                fontSize: _getDateFontSize(isMobile, isVerySmall, isUltraSmall),
                color: statusColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Status badge for mobile if needed
          if (isMobile && !isUltraSmall) ...[
            const SizedBox(height: 6),
            _buildStatusBadge(isVerySmall),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isVerySmall) {
    final statusColors = _getStatusColors();
    final statusText = _getStatusText();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isVerySmall ? 6 : 8,
        vertical: isVerySmall ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: statusColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: isVerySmall ? 10 : 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Helper methods for status colors and text
  ({Color backgroundColor, Color textColor}) _getStatusColors() {
    switch (status) {
      case 'completed':
        return (
          backgroundColor: const Color(0xFF10B981),
          textColor: const Color(0xFF10B981),
        );
      case 'in_progress':
        return (
          backgroundColor: const Color(0xFFFB9E00),
          textColor: const Color(0xFFFB9E00),
        );
      case 'pending':
      default:
        return (
          backgroundColor: const Color(0xFFE5E7EB),
          textColor: const Color(0xFF9CA3AF),
        );
    }
  }

  String _getStatusText() {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'in_progress':
        return 'In Progress';
      case 'pending':
      default:
        return 'Pending';
    }
  }

  // Responsive sizing methods
  double _getMaxItemWidth(bool isMobile, bool isTablet, double containerWidth) {
    if (isMobile) return containerWidth;
    if (isTablet) return containerWidth * 0.95;
    return 600; // Desktop max width
  }

  double _getIconColumnWidth(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 32;
    if (isMobile) return 36;
    return 40; // Desktop
  }

  double _getIconSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 32;
    if (isMobile) return 36;
    return 40; // Desktop
  }

  double _getIconInnerSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 16;
    if (isMobile) return 18;
    return 20; // Desktop
  }

  double _getBorderWidth(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 1.5;
    return 2; // Standard
  }

  double _getLineWidth(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 1.5;
    return 2; // Standard
  }

  double _getLineHeight(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 32;
    if (isMobile) return 36;
    return 40; // Desktop
  }

  double _getLineMargin(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 6;
    return 8; // Standard
  }

  double _getHorizontalSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 12;
    if (isMobile) return 16;
    return 20; // Desktop
  }

  double _getDetailsTopPadding(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 4;
    if (isMobile) return 6;
    return 8; // Desktop
  }

  double _getTitleFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 13;
    if (isVerySmall) return 14;
    return 16; // Mobile and up
  }

  double _getTitleLineHeight(bool isMobile) {
    return isMobile ? 1.3 : 1.4;
  }

  double _getDateFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 10;
    if (isVerySmall) return 11;
    return 12; // Mobile and up
  }

  double _getTitleDateSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 3;
    return 4; // Standard
  }

  double _getDatePaddingHorizontal(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 6;
    return 8; // Standard
  }

  double _getDatePaddingVertical(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 2;
    return 3; // Standard
  }

  double _getDateBorderRadius(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 8;
    return 12; // Standard
  }

  double _getItemSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 8;
    return 12; // Standard
  }
}

// Enhanced version with additional responsive features
class EnhancedStatusItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final IconData icon;
  final bool isLast;
  final VoidCallback? onTap;
  final Widget? customTrailing;

  const EnhancedStatusItemWidget({
    Key? key,
    required this.title,
    this.subtitle = '',
    required this.date,
    required this.status,
    required this.icon,
    required this.isLast,
    this.onTap,
    this.customTrailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;
        final isVerySmall = screenWidth < 400;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            margin: EdgeInsets.only(bottom: isLast ? 0 : (isMobile ? 8 : 12)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Status icon
                StatusItemWidget(
                  title: title,
                  date: date,
                  status: status,
                  icon: icon,
                  isLast: true, // No connecting line in card view
                ),
                if (customTrailing != null) ...[
                  const SizedBox(width: 12),
                  customTrailing!,
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
