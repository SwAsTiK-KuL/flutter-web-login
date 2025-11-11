import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        // Determine device type
        final bool isMobile = screenWidth < 768;
        final bool isTablet = screenWidth >= 768 && screenWidth < 1024;
        final bool isDesktop = screenWidth >= 1024;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(isMobile, isTablet),
            vertical: _getVerticalPadding(isMobile),
          ),
          child: _buildFooterContent(
            isMobile,
            isTablet,
            isDesktop,
            screenWidth,
          ),
        );
      },
    );
  }

  Widget _buildFooterContent(
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    double screenWidth,
  ) {
    // For very small mobile screens, stack the content differently
    if (isMobile && screenWidth < 400) {
      return _buildCompactMobileLayout(screenWidth);
    }

    // Standard layouts for mobile, tablet, and desktop
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _footerText(
          'CIN: U92A03MH1983PTC123356',
          isMobile,
          isTablet,
          isDesktop,
        ),
        SizedBox(height: _getSpacing(isMobile)),
        _footerText(
          'SEBI Registration Nos: Stock Broker: INZ000169536 (NSE, MCEX, BSE-418, MSEI-0604)',
          isMobile,
          isTablet,
          isDesktop,
        ),
        SizedBox(height: _getSpacing(isMobile)),
        _footerText(
          'MCX-50050/B051 and NCDEX - 01255) Depository Participant - IN-DP-516-2020 (NSDL & CDSL)',
          isMobile,
          isTablet,
          isDesktop,
        ),
      ],
    );
  }

  Widget _buildCompactMobileLayout(double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // CIN in smaller text for very small screens
        Text(
          'CIN: U92A03MH1983PTC123356',
          style: TextStyle(
            fontSize: 8,
            color: Colors.grey.shade600,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),

        // SEBI Registration - split into multiple lines if needed
        Column(
          children: [
            Text(
              'SEBI Registration Nos: Stock Broker:',
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey.shade600,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'INZ000169536 (NSE, MCEX, BSE-418, MSEI-0604)',
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey.shade600,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 6),

        // MCX and Depository info - split for readability
        Column(
          children: [
            Text(
              'MCX-50050/B051 and NCDEX - 01255)',
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey.shade600,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Depository Participant - IN-DP-516-2020 (NSDL & CDSL)',
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey.shade600,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _footerText(
    String text,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: _getMaxTextWidth(isMobile, isTablet, isDesktop),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: _getFontSize(isMobile, isTablet, isDesktop),
          color: Colors.grey.shade600,
          height: _getLineHeight(isMobile),
          letterSpacing: _getLetterSpacing(isMobile),
        ),
        textAlign: TextAlign.center,
        softWrap: true,
      ),
    );
  }

  // Responsive sizing methods
  double _getHorizontalPadding(bool isMobile, bool isTablet) {
    if (isMobile) return 12.0;
    if (isTablet) return 20.0;
    return 24.0; // Desktop
  }

  double _getVerticalPadding(bool isMobile) {
    return isMobile ? 8.0 : 12.0;
  }

  double _getSpacing(bool isMobile) {
    return isMobile ? 3.0 : 4.0;
  }

  double _getFontSize(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) return 9.0;
    if (isTablet) return 9.5;
    return 10.0; // Desktop
  }

  double _getLineHeight(bool isMobile) {
    return isMobile ? 1.3 : 1.4;
  }

  double _getLetterSpacing(bool isMobile) {
    return isMobile ? 0.1 : 0.2;
  }

  double _getMaxTextWidth(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) return 350;
    if (isTablet) return 600;
    return 800; // Desktop
  }
}

// Alternative simplified footer for cases where space is very limited
class CompactFooterWidget extends StatelessWidget {
  const CompactFooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return Container(
          padding: EdgeInsets.all(isMobile ? 8.0 : 12.0),
          child: Column(
            children: [
              Text(
                'CIN: U92A03MH1983PTC123356',
                style: TextStyle(
                  fontSize: isMobile ? 8 : 9,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'SEBI Registration & Depository Details Available',
                style: TextStyle(
                  fontSize: isMobile ? 8 : 9,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Extended footer with additional responsive features
class EnhancedFooterWidget extends StatelessWidget {
  const EnhancedFooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16.0 : 24.0,
            vertical: isMobile ? 12.0 : 16.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: Column(
            children: [
              // Main regulatory information
              const FooterWidget(),

              if (!isMobile) ...[
                const SizedBox(height: 16),
                // Additional desktop-only content
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  children: [
                    _buildFooterLink('Privacy Policy'),
                    _buildFooterLink('Terms & Conditions'),
                    _buildFooterLink('Risk Disclosure'),
                    _buildFooterLink('Contact Us'),
                  ],
                ),
              ],

              const SizedBox(height: 8),
              Text(
                '© ${DateTime.now().year} PhillipCapital India. All rights reserved.',
                style: TextStyle(
                  fontSize: isMobile ? 8 : 9,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooterLink(String text) {
    return InkWell(
      onTap: () {
        // Handle link navigation
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 9,
            color: Colors.blue.shade600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
