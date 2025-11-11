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

  Widget _buildStepIcon(String assetPath, bool isCompleted, bool isActive) {
    final iconColor =
        isCompleted || isActive ? Colors.white : AppColors.inactiveText;

    if (isCompleted) {
      return Icon(Icons.check, size: 20, color: Colors.white);
    }

    if (isActive) {
      return Icon(Icons.person, size: 20, color: Colors.white);
    }

    if (assetPath.contains('verify')) {
      return Icon(Icons.verified_user, size: 18, color: AppColors.inactiveText);
    }

    if (assetPath.contains('ipv')) {
      return Icon(Icons.description, size: 18, color: AppColors.inactiveText);
    }

    return SvgPicture.asset(
      assetPath,
      width: 18,
      height: 18,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      placeholderBuilder:
          (context) => Icon(
            _getFallbackIcon(assetPath, isCompleted, isActive),
            size: 18,
            color: iconColor,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> steps = [
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
        child: Column(
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
                          width: 40,
                          height: 40,
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
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
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
                        margin: const EdgeInsets.only(
                          left: 20,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Container(
                          width: 2,
                          height: 40,
                          color:
                              isCompleted
                                  ? AppColors.completed
                                  : AppColors.inactive,
                        ),
                      ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
