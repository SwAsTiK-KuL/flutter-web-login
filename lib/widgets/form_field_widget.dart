import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isRequired;
  final String? errorText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;

  const AppTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isRequired = false,
    this.errorText,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
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
            maxWidth: _getMaxFieldWidth(isMobile, isTablet, containerWidth),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(isMobile, isVerySmall, isUltraSmall),
              SizedBox(height: _getLabelSpacing(isMobile, isVerySmall)),
              _buildTextField(isMobile, isTablet, isVerySmall, isUltraSmall),
              if (errorText != null) ...[
                SizedBox(height: _getErrorSpacing(isMobile)),
                _buildErrorText(isMobile, isVerySmall),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: _getLabelFontSize(isMobile, isVerySmall, isUltraSmall),
              fontWeight: FontWeight.w500,
              color: enabled ? const Color(0xFF374151) : AppColors.inactiveText,
              height: _getLabelLineHeight(isMobile),
            ),
            maxLines: isUltraSmall ? 2 : null,
            overflow: isUltraSmall ? TextOverflow.ellipsis : null,
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(
              fontSize: _getLabelFontSize(isMobile, isVerySmall, isUltraSmall),
              color: AppColors.errorRed,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          _getBorderRadius(isMobile, isVerySmall),
        ),
        border: Border.all(
          color:
              errorText != null
                  ? AppColors.errorRed
                  : enabled
                  ? AppColors.borderColor
                  : AppColors.inactiveText,
          width: _getBorderWidth(isMobile, errorText != null),
        ),
        color: enabled ? Colors.white : const Color(0xFFF9FAFB),
        boxShadow:
            enabled && !isMobile
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
                : null,
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.inactiveText,
            fontSize: _getInputFontSize(isMobile, isVerySmall, isUltraSmall),
          ),
          border: InputBorder.none,
          contentPadding: _getInputPadding(
            isMobile,
            isTablet,
            isVerySmall,
            maxLines,
          ),
          counterStyle: TextStyle(
            fontSize: _getCounterFontSize(isMobile, isVerySmall),
            color: AppColors.textGray,
          ),
        ),
        style: TextStyle(
          fontSize: _getInputFontSize(isMobile, isVerySmall, isUltraSmall),
          color: enabled ? const Color(0xFF374151) : AppColors.inactiveText,
          height: _getInputLineHeight(isMobile),
        ),
      ),
    );
  }

  Widget _buildErrorText(bool isMobile, bool isVerySmall) {
    return Row(
      children: [
        Icon(
          Icons.error_outline,
          size: _getErrorIconSize(isMobile, isVerySmall),
          color: AppColors.errorRed,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            errorText!,
            style: TextStyle(
              fontSize: _getErrorFontSize(isMobile, isVerySmall),
              color: AppColors.errorRed,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  // Responsive sizing methods for AppTextField
  double _getMaxFieldWidth(
    bool isMobile,
    bool isTablet,
    double containerWidth,
  ) {
    if (isMobile) return containerWidth;
    if (isTablet) return containerWidth * 0.95;
    return 400; // Desktop max width
  }

  double _getLabelFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 12;
    if (isVerySmall) return 13;
    return 14; // Standard
  }

  double _getInputFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 13;
    if (isVerySmall) return 14;
    return 14; // Standard
  }

  double _getErrorFontSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 11;
    return 12; // Standard
  }

  double _getCounterFontSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 10;
    return 11; // Standard
  }

  double _getErrorIconSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 14;
    return 16; // Standard
  }

  double _getLabelLineHeight(bool isMobile) {
    return isMobile ? 1.3 : 1.4;
  }

  double _getInputLineHeight(bool isMobile) {
    return isMobile ? 1.4 : 1.5;
  }

  double _getBorderRadius(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 6;
    return 8; // Standard
  }

  double _getBorderWidth(bool isMobile, bool hasError) {
    if (hasError) return 1.5;
    return 1; // Standard
  }

  double _getLabelSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 6;
    return 8; // Standard
  }

  double _getErrorSpacing(bool isMobile) {
    return 6;
  }

  EdgeInsets _getInputPadding(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    int? maxLines,
  ) {
    final baseVertical = isVerySmall ? 12.0 : 16.0;
    final baseHorizontal = isVerySmall ? 12.0 : 16.0;

    if (maxLines != null && maxLines > 1) {
      return EdgeInsets.symmetric(
        horizontal: baseHorizontal,
        vertical: baseVertical + 4,
      );
    }

    return EdgeInsets.symmetric(
      horizontal: baseHorizontal,
      vertical: baseVertical,
    );
  }
}

class AppDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final bool isRequired;
  final String? errorText;
  final bool enabled;

  const AppDropdownField({
    Key? key,
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.errorText,
    this.enabled = true,
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
            maxWidth: _getMaxFieldWidth(isMobile, isTablet, containerWidth),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(isMobile, isVerySmall, isUltraSmall),
              SizedBox(height: _getLabelSpacing(isMobile, isVerySmall)),
              _buildDropdownField(
                isMobile,
                isTablet,
                isVerySmall,
                isUltraSmall,
              ),
              if (errorText != null) ...[
                SizedBox(height: _getErrorSpacing(isMobile)),
                _buildErrorText(isMobile, isVerySmall),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: _getLabelFontSize(isMobile, isVerySmall, isUltraSmall),
              fontWeight: FontWeight.w500,
              color: enabled ? const Color(0xFF374151) : AppColors.inactiveText,
              height: _getLabelLineHeight(isMobile),
            ),
            maxLines: isUltraSmall ? 2 : null,
            overflow: isUltraSmall ? TextOverflow.ellipsis : null,
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(
              fontSize: _getLabelFontSize(isMobile, isVerySmall, isUltraSmall),
              color: AppColors.errorRed,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownField(
    bool isMobile,
    bool isTablet,
    bool isVerySmall,
    bool isUltraSmall,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          _getBorderRadius(isMobile, isVerySmall),
        ),
        border: Border.all(
          color:
              errorText != null
                  ? AppColors.errorRed
                  : enabled
                  ? AppColors.borderColor
                  : AppColors.inactiveText,
          width: _getBorderWidth(isMobile, errorText != null),
        ),
        color: enabled ? Colors.white : const Color(0xFFF9FAFB),
        boxShadow:
            enabled && !isMobile
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
                : null,
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: enabled ? onChanged : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.inactiveText,
            fontSize: _getInputFontSize(isMobile, isVerySmall, isUltraSmall),
          ),
          border: InputBorder.none,
          contentPadding: _getInputPadding(isMobile, isTablet, isVerySmall),
        ),
        style: TextStyle(
          fontSize: _getInputFontSize(isMobile, isVerySmall, isUltraSmall),
          color: enabled ? const Color(0xFF374151) : AppColors.inactiveText,
          height: _getInputLineHeight(isMobile),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: enabled ? AppColors.textGray : AppColors.inactiveText,
          size: _getDropdownIconSize(isMobile, isVerySmall),
        ),
        isExpanded: true,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(
          _getBorderRadius(isMobile, isVerySmall),
        ),
        items:
            items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: _getInputFontSize(
                          isMobile,
                          isVerySmall,
                          isUltraSmall,
                        ),
                        color: const Color(0xFF374151),
                      ),
                      overflow: isVerySmall ? TextOverflow.ellipsis : null,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildErrorText(bool isMobile, bool isVerySmall) {
    return Row(
      children: [
        Icon(
          Icons.error_outline,
          size: _getErrorIconSize(isMobile, isVerySmall),
          color: AppColors.errorRed,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            errorText!,
            style: TextStyle(
              fontSize: _getErrorFontSize(isMobile, isVerySmall),
              color: AppColors.errorRed,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  // Responsive sizing methods for AppDropdownField
  double _getMaxFieldWidth(
    bool isMobile,
    bool isTablet,
    double containerWidth,
  ) {
    if (isMobile) return containerWidth;
    if (isTablet) return containerWidth * 0.95;
    return 400; // Desktop max width
  }

  double _getLabelFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 12;
    if (isVerySmall) return 13;
    return 14; // Standard
  }

  double _getInputFontSize(bool isMobile, bool isVerySmall, bool isUltraSmall) {
    if (isUltraSmall) return 13;
    if (isVerySmall) return 14;
    return 14; // Standard
  }

  double _getErrorFontSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 11;
    return 12; // Standard
  }

  double _getErrorIconSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 14;
    return 16; // Standard
  }

  double _getDropdownIconSize(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 20;
    return 24; // Standard
  }

  double _getLabelLineHeight(bool isMobile) {
    return isMobile ? 1.3 : 1.4;
  }

  double _getInputLineHeight(bool isMobile) {
    return isMobile ? 1.4 : 1.5;
  }

  double _getBorderRadius(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 6;
    return 8; // Standard
  }

  double _getBorderWidth(bool isMobile, bool hasError) {
    if (hasError) return 1.5;
    return 1; // Standard
  }

  double _getLabelSpacing(bool isMobile, bool isVerySmall) {
    if (isVerySmall) return 6;
    return 8; // Standard
  }

  double _getErrorSpacing(bool isMobile) {
    return 6;
  }

  EdgeInsets _getInputPadding(bool isMobile, bool isTablet, bool isVerySmall) {
    final baseVertical = isVerySmall ? 12.0 : 16.0;
    final baseHorizontal = isVerySmall ? 12.0 : 16.0;

    return EdgeInsets.symmetric(
      horizontal: baseHorizontal,
      vertical: baseVertical,
    );
  }
}
