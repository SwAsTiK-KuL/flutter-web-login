import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../generated/assets.dart';
import '../utils/constants.dart';

class ProgressSidebarWidget extends StatelessWidget {
  const ProgressSidebarWidget({super.key});

  IconData _getFallbackIcon(String assetPath, bool isCompleted, bool isActive) {
    if (isCompleted) return Icons.check;
    if (assetPath.contains('person') || isActive) return Icons.person;
    if (assetPath.contains('verify')) return Icons.verified_user;
    if (assetPath.contains('ipv')) return Icons.description;
    return Icons.circle;
  }

  Widget _buildStepIcon(
    String assetPath,
    bool isCompleted,
    bool isActive,
    bool isMobile,
    bool isCompact,
  ) {
    final iconColor =
        isCompleted || isActive ? Colors.white : AppColors.inactiveText;
    final iconSize = _getIconSize(isMobile, isCompact);

    if (isCompleted) {
      return Icon(Icons.check, size: iconSize, color: Colors.white);
    }

    if (isActive) {
      return Icon(Icons.person, size: iconSize, color: Colors.white);
    }

    if (assetPath.contains('verify')) {
      return Icon(
        Icons.verified_user,
        size: iconSize - 2,
        color: AppColors.inactiveText,
      );
    }

    if (assetPath.contains('ipv')) {
      return Icon(
        Icons.description,
        size: iconSize - 2,
        color: AppColors.inactiveText,
      );
    }

    return SvgPicture.asset(
      assetPath,
      width: iconSize,
      height: iconSize,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      placeholderBuilder:
          (context) => Icon(
            _getFallbackIcon(assetPath, isCompleted, isActive),
            size: iconSize,
            color: iconColor,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final availableHeight = constraints.maxHeight;

        // Determine device type and layout
        final bool isMobile = screenWidth < 768;
        final bool isTablet = screenWidth >= 768 && screenWidth < 1024;
        final bool isVerySmall = screenWidth < 400;

        // For mobile, we might want to show this horizontally at the top
        if (isMobile) {
          return _buildMobileSidebar(isVerySmall, availableHeight);
        } else if (isTablet) {
          return _buildTabletSidebar();
        } else {
          return _buildDesktopSidebar();
        }
      },
    );
  }

  // Desktop Layout (≥ 1024px)
  Widget _buildDesktopSidebar() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.sidebarBg.withValues(alpha: 0.3),
        border: const Border(
          right: BorderSide(color: AppColors.sidebarBg, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _buildStepsList(false, false, false),
      ),
    );
  }

  // Tablet Layout (768px - 1023px)
  Widget _buildTabletSidebar() {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: AppColors.sidebarBg.withValues(alpha: 0.3),
        border: const Border(
          right: BorderSide(color: AppColors.sidebarBg, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildStepsList(false, true, false),
      ),
    );
  }

  // Mobile Layout (< 768px)
  Widget _buildMobileSidebar(bool isVerySmall, double availableHeight) {
    // For very small screens or limited height, use horizontal layout
    if (isVerySmall || availableHeight < 400) {
      return _buildHorizontalProgress(isVerySmall);
    }

    // For standard mobile, use compact vertical layout
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.sidebarBg.withValues(alpha: 0.3),
        border: const Border(
          right: BorderSide(color: AppColors.sidebarBg, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildStepsList(true, false, true),
      ),
    );
  }

  // Horizontal progress for very small screens
  Widget _buildHorizontalProgress(bool isVerySmall) {
    final steps = _getStepsData();

    return Container(
      height: isVerySmall ? 60 : 80,
      decoration: BoxDecoration(
        color: AppColors.sidebarBg.withValues(alpha: 0.3),
        border: const Border(
          bottom: BorderSide(color: AppColors.sidebarBg, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isVerySmall ? 12.0 : 16.0,
          vertical: isVerySmall ? 8.0 : 12.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              steps.asMap().entries.map((entry) {
                final int index = entry.key;
                final Map<String, Object> step = entry.value;
                final bool isLast = index == steps.length - 1;

                final bool isCompleted = step['completed'] as bool;
                final bool isActive = step['active'] as bool;
                final String assetPath = step['assetPath'] as String;
                final String title = step['title'] as String;

                return Expanded(
                  child: Row(
                    children: [
                      _buildHorizontalStep(
                        assetPath,
                        isCompleted,
                        isActive,
                        title,
                        isVerySmall,
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            height: 2,
                            margin: EdgeInsets.symmetric(
                              horizontal: isVerySmall ? 4 : 8,
                            ),
                            color:
                                isCompleted
                                    ? AppColors.completed
                                    : AppColors.inactive,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildHorizontalStep(
    String assetPath,
    bool isCompleted,
    bool isActive,
    String title,
    bool isVerySmall,
  ) {
    final circleSize = isVerySmall ? 24.0 : 32.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isCompleted
                    ? AppColors.completed
                    : isActive
                    ? AppColors.active
                    : AppColors.inactive,
          ),
          child: Center(
            child: _buildStepIcon(
              assetPath,
              isCompleted,
              isActive,
              true,
              isVerySmall,
            ),
          ),
        ),
        if (!isVerySmall) ...[
          const SizedBox(height: 4),
          Text(
            title.replaceAll('\n', ' '),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color:
                  isActive
                      ? AppColors.active
                      : isCompleted
                      ? AppColors.completed
                      : AppColors.textGray,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildStepsList(bool isMobile, bool isCompact, bool isVeryCompact) {
    final steps = _getStepsData();

    return Column(
      children:
          steps.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, Object> step = entry.value;
            final bool isLast = index == steps.length - 1;

            final bool isCompleted = step['completed'] as bool;
            final bool isActive = step['active'] as bool;
            final String assetPath = step['assetPath'] as String;
            final String title = step['title'] as String;

            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: _getCircleSize(isMobile, isCompact),
                      height: _getCircleSize(isMobile, isCompact),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isCompleted
                                ? AppColors.completed
                                : isActive
                                ? AppColors.active
                                : AppColors.inactive,
                      ),
                      child: Center(
                        child: _buildStepIcon(
                          assetPath,
                          isCompleted,
                          isActive,
                          isMobile,
                          isCompact,
                        ),
                      ),
                    ),
                    SizedBox(width: _getHorizontalSpacing(isMobile, isCompact)),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: _getTextSize(isMobile, isCompact),
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          color:
                              isActive
                                  ? AppColors.active
                                  : isCompleted
                                  ? AppColors.completed
                                  : AppColors.textGray,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isLast)
                  Container(
                    margin: EdgeInsets.only(
                      left: _getCircleSize(isMobile, isCompact) / 2,
                      top: _getVerticalSpacing(isMobile, isCompact),
                      bottom: _getVerticalSpacing(isMobile, isCompact),
                    ),
                    child: Container(
                      width: 2,
                      height: _getConnectorHeight(isMobile, isCompact),
                      color:
                          isCompleted
                              ? AppColors.completed
                              : AppColors.inactive,
                    ),
                  ),
              ],
            );
          }).toList(),
    );
  }

  List<Map<String, Object>> _getStepsData() {
    return [
      {
        'title': 'Identity',
        'completed': true,
        'active': false,
        'assetPath': Assets.assetsTickPng,
      },
      {
        'title': 'Bank Details',
        'completed': true,
        'active': false,
        'assetPath': Assets.assetsTickPng,
      },
      {
        'title': 'Personal\nInfo',
        'completed': false,
        'active': true,
        'assetPath': Assets.assetsPersonPng,
      },
      {
        'title': 'Verify',
        'completed': false,
        'active': false,
        'assetPath': Assets.assetsVerify,
      },
      {
        'title': 'IPV& ESIGN',
        'completed': false,
        'active': false,
        'assetPath': Assets.assetsIpv,
      },
    ];
  }

  // Responsive sizing methods
  double _getCircleSize(bool isMobile, bool isCompact) {
    if (isCompact) return 32;
    if (isMobile) return 36;
    return 40; // Desktop
  }

  double _getIconSize(bool isMobile, bool isCompact) {
    if (isCompact) return 16;
    if (isMobile) return 18;
    return 20; // Desktop
  }

  double _getTextSize(bool isMobile, bool isCompact) {
    if (isCompact) return 12;
    return 14; // Mobile and Desktop
  }

  double _getHorizontalSpacing(bool isMobile, bool isCompact) {
    if (isCompact) return 12;
    return 16; // Mobile and Desktop
  }

  double _getVerticalSpacing(bool isMobile, bool isCompact) {
    if (isCompact) return 6;
    return 8; // Mobile and Desktop
  }

  double _getConnectorHeight(bool isMobile, bool isCompact) {
    if (isCompact) return 32;
    if (isMobile) return 36;
    return 40; // Desktop
  }
}

// Alternative compact progress indicator for very constrained spaces
class CompactProgressIndicator extends StatelessWidget {
  const CompactProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: AppColors.inactive,
      ),
      child: Row(
        children: [
          // Progress completed (40% - Identity + Bank Details)
          Expanded(
            flex: 40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                ),
                color: AppColors.completed,
              ),
            ),
          ),
          // Current step (20% - Personal Info)
          Expanded(flex: 20, child: Container(color: AppColors.active)),
          // Remaining steps (40% - Verify + IPV)
          const Expanded(flex: 40, child: SizedBox()),
        ],
      ),
    );
  }
}
