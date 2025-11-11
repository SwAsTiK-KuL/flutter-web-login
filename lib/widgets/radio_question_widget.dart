import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RadioQuestionWidget extends StatelessWidget {
  final String question;
  final bool? value;
  final Function(bool?) onChanged;

  const RadioQuestionWidget({
    Key? key,
    required this.question,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final availableWidth = constraints.maxWidth;

        // Determine device type and layout strategy
        final bool isMobile = screenWidth < 768;
        final bool isTablet = screenWidth >= 768 && screenWidth < 1024;
        final bool isVerySmall = screenWidth < 400;
        final bool isUltraSmall = screenWidth < 350;

        return Container(
          constraints: BoxConstraints(
            maxWidth: _getMaxWidth(isMobile, isTablet, availableWidth),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuestion(isMobile, isVerySmall, isUltraSmall),
              SizedBox(height: _getQuestionSpacing(isMobile, isVerySmall)),
              _buildRadioOptions(
                isMobile,
                isTablet,
                isVerySmall,
                isUltraSmall,
                availableWidth,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestion(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    return Text(
      question,
      style: TextStyle(
        fontSize: _getQuestionFontSize(isMobile, isVerySmall, isUltraSmall),
        fontWeight: FontWeight.w500,
        color: const Color(0xFF374151),
        height: _getLineHeight(isMobile),
      ),
      softWrap: true,
      maxLines: isUltraSmall ? 3 : null,
      overflow: isUltraSmall ? TextOverflow.ellipsis : null,
    );
  }

  Widget _buildRadioOptions(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    bool isUltraSmall,
    double availableWidth,
  ) {
    // For very small screens or long questions, use vertical layout
    if (isUltraSmall || (isMobile && question.length > 50)) {
      return _buildVerticalRadioOptions(isMobile, isVerySmall, isUltraSmall);
    }

    // For larger screens or short questions, use horizontal layout
    return _buildHorizontalRadioOptions(
      isMobile,
      isTablet,
      isVerySmall,
      availableWidth,
    );
  }

  Widget _buildHorizontalRadioOptions(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    double availableWidth,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildRadioOption(
            value: true,
            label: 'Yes',
            isMobile: isMobile,
            isTablet: isTablet,
            isVerySmall: isVerySmall,
          ),
        ),
        SizedBox(width: _getOptionSpacing(isMobile, isVerySmall)),
        Expanded(
          child: _buildRadioOption(
            value: false,
            label: 'No',
            isMobile: isMobile,
            isTablet: isTablet,
            isVerySmall: isVerySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalRadioOptions(
    bool isMobile,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRadioOption(
          value: true,
          label: 'Yes',
          isMobile: isMobile,
          isTablet: false,
          isVerySmall: isVerySmall,
        ),
        SizedBox(height: _getVerticalOptionSpacing(isVerySmall, isUltraSmall)),
        _buildRadioOption(
          value: false,
          label: 'No',
          isMobile: isMobile,
          isTablet: false,
          isVerySmall: isVerySmall,
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required bool value,
    required String label,
    required bool isMobile,
    required bool isTablet,
    required bool isVerySmall,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _getOptionHorizontalPadding(isMobile, isVerySmall),
          vertical: _getOptionVerticalPadding(isMobile, isVerySmall),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border:
              this.value == value
                  ? Border.all(
                    color: AppColors.active.withOpacity(0.3),
                    width: 1,
                  )
                  : null,
          color:
              this.value == value ? AppColors.active.withOpacity(0.05) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _getRadioSize(isMobile, isVerySmall),
              height: _getRadioSize(isMobile, isVerySmall),
              child: Radio<bool>(
                value: value,
                groupValue: this.value,
                onChanged: onChanged,
                activeColor: AppColors.active,
                materialTapTargetSize:
                    isMobile
                        ? MaterialTapTargetSize.padded
                        : MaterialTapTargetSize.shrinkWrap,
                visualDensity:
                    isMobile
                        ? VisualDensity.comfortable
                        : VisualDensity.compact,
              ),
            ),
            SizedBox(width: _getLabelSpacing(isMobile, isVerySmall)),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: _getLabelFontSize(isMobile, isVerySmall),
                  color:
                      this.value == value
                          ? AppColors.active
                          : const Color(0xFF374151),
                  fontWeight:
                      this.value == value ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Responsive sizing methods
  double _getMaxWidth(bool isMobile, bool isTablet, double availableWidth) {
    if (isMobile) return availableWidth;
    if (isTablet) return availableWidth * 0.9;
    return 400; // Desktop max width
  }

  double _getQuestionFontSize(
    bool isMobile,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    if (isUltraSmall) return 12;
    if (isVerySmall) return 13;
    return 14; // Mobile and up
  }

  double _getLabelFontSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 12;
    return 14; // Mobile and up
  }

  double _getLineHeight(bool isMobile) {
    return isMobile ? 1.3 : 1.4;
  }

  double _getQuestionSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 8;
    return 12; // Mobile and up
  }

  double _getOptionSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 12;
    if (isMobile) return 16;
    return 20; // Desktop
  }

  double _getVerticalOptionSpacing(bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 6;
    if (isVerySmall) return 8;
    return 10; // Standard
  }

  double _getOptionHorizontalPadding(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 6;
    return 8; // Mobile and up
  }

  double _getOptionVerticalPadding(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 6;
    if (isMobile) return 8;
    return 10; // Desktop
  }

  double _getRadioSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 18;
    if (isMobile) return 20;
    return 20; // Desktop
  }

  double _getLabelSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 6;
    return 8; // Mobile and up
  }
}

// Enhanced version with additional features
class EnhancedRadioQuestionWidget extends StatelessWidget {
  final String question;
  final String? description;
  final bool? value;
  final Function(bool?) onChanged;
  final bool isRequired;
  final String? errorText;
  final List<String>? customOptions; // For custom Yes/No labels

  const EnhancedRadioQuestionWidget({
    Key? key,
    required this.question,
    this.description,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.errorText,
    this.customOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;
        final isVerySmall = screenWidth < 400;

        return Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 400,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question with required indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        fontSize: isVerySmall ? 13 : 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF374151),
                        height: isMobile ? 1.3 : 1.4,
                      ),
                    ),
                  ),
                  if (isRequired)
                    Text(
                      ' *',
                      style: TextStyle(
                        fontSize: isVerySmall ? 13 : 14,
                        color: AppColors.errorRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),

              // Description if provided
              if (description != null) ...[
                const SizedBox(height: 4),
                Text(
                  description!,
                  style: TextStyle(
                    fontSize: isVerySmall ? 11 : 12,
                    color: AppColors.textGray,
                    height: 1.3,
                  ),
                ),
              ],

              SizedBox(height: isVerySmall ? 8 : 12),

              // Radio options
              _buildEnhancedRadioOptions(isMobile, isVerySmall),

              // Error text if provided
              if (errorText != null) ...[
                const SizedBox(height: 6),
                Text(
                  errorText!,
                  style: TextStyle(
                    fontSize: isVerySmall ? 10 : 11,
                    color: AppColors.errorRed,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnhancedRadioOptions(bool isMobile, bool isVerySmall) {
    final yesLabel = customOptions?[0] ?? 'Yes';
    final noLabel = customOptions?[1] ?? 'No';

    return Wrap(
      spacing: isMobile ? 12 : 16,
      runSpacing: 8,
      children: [
        _buildEnhancedRadioOption(
          value: true,
          label: yesLabel,
          isMobile: isMobile,
          isVerySmall: isVerySmall,
        ),
        _buildEnhancedRadioOption(
          value: false,
          label: noLabel,
          isMobile: isMobile,
          isVerySmall: isVerySmall,
        ),
      ],
    );
  }

  Widget _buildEnhancedRadioOption({
    required bool value,
    required String label,
    required bool isMobile,
    required bool isVerySmall,
  }) {
    final isSelected = this.value == value;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isVerySmall ? 12 : 16,
          vertical: isVerySmall ? 8 : 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.active : AppColors.borderColor,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? AppColors.active.withOpacity(0.1) : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isVerySmall ? 16 : 18,
              height: isVerySmall ? 16 : 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.active : AppColors.borderColor,
                  width: 2,
                ),
                color: isSelected ? AppColors.active : Colors.transparent,
              ),
              child:
                  isSelected
                      ? Icon(
                        Icons.check,
                        size: isVerySmall ? 10 : 12,
                        color: Colors.white,
                      )
                      : null,
            ),
            SizedBox(width: isVerySmall ? 6 : 8),
            Text(
              label,
              style: TextStyle(
                fontSize: isVerySmall ? 12 : 14,
                color: isSelected ? AppColors.active : const Color(0xFF374151),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
