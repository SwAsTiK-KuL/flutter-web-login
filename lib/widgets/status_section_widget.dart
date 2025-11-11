import 'package:flutter/material.dart';
import 'status_item_widget.dart';

class StatusSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> steps;

  const StatusSectionWidget({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = MediaQuery.of(context).size.height;

        // Determine device type and layout strategy
        final bool isMobile = screenWidth < 768;
        final bool isTablet = screenWidth >= 768 && screenWidth < 1024;
        final bool isDesktop = screenWidth >= 1024;
        final bool isVerySmall = screenWidth < 400;
        final bool isLandscape = screenWidth > screenHeight;

        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: _getMaxWidth(isMobile, isTablet, isDesktop),
              maxHeight: _getMaxHeight(screenHeight, isMobile),
            ),
            width: _getContainerWidth(
              isMobile,
              isTablet,
              isVerySmall,
              screenWidth,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: _getHorizontalMargin(isMobile, isVerySmall),
              vertical: _getVerticalMargin(isMobile, isLandscape),
            ),
            padding: _getContainerPadding(isMobile, isTablet, isVerySmall),
            decoration: _getContainerDecoration(isMobile, isVerySmall),
            child: _buildContent(isMobile, isTablet, isVerySmall, isLandscape),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    bool isLandscape,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile, isTablet, isVerySmall),
          SizedBox(height: _getHeaderSpacing(isMobile, isVerySmall)),
          _buildStatusList(isMobile, isTablet, isVerySmall),
          if (isMobile) _buildMobileFooter(isVerySmall),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile, bool isTablet, bool isVerySmall) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Application Status',
          style: TextStyle(
            fontSize: _getTitleFontSize(isMobile, isVerySmall),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
            height: 1.2,
          ),
        ),
        if (isMobile) ...[
          const SizedBox(height: 8),
          _buildProgressIndicator(isVerySmall),
        ],
      ],
    );
  }

  Widget _buildProgressIndicator(bool isVerySmall) {
    final completedSteps =
        steps.where((step) => step['status'] == 'completed').length;
    final totalSteps = steps.length;
    final progress = completedSteps / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: isVerySmall ? 12 : 14,
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$completedSteps of $totalSteps completed',
              style: TextStyle(
                fontSize: isVerySmall ? 10 : 12,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            minHeight: isVerySmall ? 6 : 8,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusList(bool isMobile, bool isTablet, bool isVerySmall) {
    if (isMobile && isVerySmall) {
      return _buildCompactStatusList(isVerySmall);
    }

    return Column(
      children:
          steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;

            return Container(
              margin: EdgeInsets.only(
                bottom: isLast ? 0 : _getItemSpacing(isMobile, isVerySmall),
              ),
              child: StatusItemWidget(
                title: step['title'],
                date: step['date'],
                status: step['status'],
                icon: step['icon'],
                isLast: isLast,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCompactStatusList(bool isVerySmall) {
    return Column(
      children:
          steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;

            return Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Row(
                children: [
                  _buildCompactStatusIcon(step['status'], step['icon']),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'],
                          style: TextStyle(
                            fontSize: isVerySmall ? 12 : 14,
                            fontWeight: FontWeight.w600,
                            color:
                                step['status'] == 'pending'
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF111827),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step['date'],
                          style: TextStyle(
                            fontSize: isVerySmall ? 10 : 11,
                            color: _getStatusColor(step['status']),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(step['status'], isVerySmall),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCompactStatusIcon(String status, IconData icon) {
    final color = _getStatusColor(status);
    final isPending = status == 'pending';

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPending ? const Color(0xFFE5E7EB) : color,
        border:
            isPending
                ? Border.all(color: const Color(0xFFE5E7EB), width: 1)
                : null,
      ),
      child: Icon(
        icon,
        size: 12,
        color: isPending ? const Color(0xFF9CA3AF) : Colors.white,
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isVerySmall) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isVerySmall ? 6 : 8,
        vertical: isVerySmall ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isVerySmall ? 9 : 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMobileFooter(bool isVerySmall) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(isVerySmall ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF0EA5E9).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: const Color(0xFF0EA5E9),
            size: isVerySmall ? 16 : 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'We\'ll notify you when your application status changes.',
              style: TextStyle(
                fontSize: isVerySmall ? 11 : 12,
                color: const Color(0xFF0EA5E9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'in_progress':
        return const Color(0xFFFB9E00);
      case 'pending':
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Done';
      case 'in_progress':
        return 'Active';
      case 'pending':
      default:
        return 'Pending';
    }
  }

  // Responsive sizing methods
  double _getMaxWidth(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) return double.infinity;
    if (isTablet) return 600;
    return 500; // Desktop
  }

  double _getMaxHeight(double screenHeight, bool isMobile) {
    if (isMobile) return screenHeight * 0.8;
    return double.infinity;
  }

  double _getContainerWidth(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    double screenWidth,
  ) {
    if (isMobile) return screenWidth * (isVerySmall ? 0.95 : 0.9);
    if (isTablet) return 600;
    return 500; // Desktop
  }

  double _getHorizontalMargin(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 8;
    if (isMobile) return 16;
    return 0; // Desktop (centered)
  }

  double _getVerticalMargin(bool isMobile, bool isLandscape) {
    if (isMobile && isLandscape) return 8;
    if (isMobile) return 16;
    return 0; // Desktop
  }

  EdgeInsets _getContainerPadding(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
  ) {
    if (isVerySmall) return const EdgeInsets.all(16);
    if (isMobile) return const EdgeInsets.all(20);
    if (isTablet) return const EdgeInsets.all(32);
    return const EdgeInsets.all(40); // Desktop
  }

  BoxDecoration _getContainerDecoration(bool isMobile, bool isVerySmall) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isVerySmall ? 0.03 : 0.05),
          blurRadius: isMobile ? 10 : 20,
          offset: Offset(0, isMobile ? 5 : 10),
        ),
      ],
    );
  }

  double _getTitleFontSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 20;
    if (isMobile) return 24;
    return 28; // Desktop
  }

  double _getHeaderSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 20;
    if (isMobile) return 24;
    return 40; // Desktop
  }

  double _getItemSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 8;
    if (isMobile) return 12;
    return 16; // Desktop
  }
}
