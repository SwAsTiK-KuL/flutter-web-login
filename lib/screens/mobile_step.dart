import 'package:flutter/material.dart';
import 'package:philip_capital_india/widgets/phone_footer_widget.dart';
import 'package:philip_capital_india/widgets/phone_section_widget.dart';
import 'package:philip_capital_india/widgets/header_widget.dart';
import 'package:philip_capital_india/widgets/login_image_widget.dart';

class PhillipCapitalOnboardingScreen extends StatelessWidget {
  const PhillipCapitalOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg-image-png.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const HeaderWidget(),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildResponsiveContent(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveContent(BuildContext context) {
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

        if (isMobile) {
          return _buildMobileLayout(isVerySmall, isLandscape);
        } else if (isTablet) {
          return _buildTabletLayout(isLandscape);
        } else {
          return _buildDesktopLayout();
        }
      },
    );
  }

  // Desktop Layout (≥ 1024px)
  Widget _buildDesktopLayout() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),

            // Main content area with transparent container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(60),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 2,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: const FormSectionWidget(),
                    ),
                  ),
                  const SizedBox(width: 80),
                  const Expanded(flex: 2, child: LoginImageWidget()),
                  const SizedBox(width: 60),
                ],
              ),
            ),

            const SizedBox(height: 80),
            const FooterWidget(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Tablet Layout (768px - 1023px)
  Widget _buildTabletLayout(bool isLandscape) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: isLandscape ? 40 : 60),

          // Main content with responsive container
          Container(
            constraints: const BoxConstraints(maxWidth: 900),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(isLandscape ? 30 : 40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child:
                isLandscape
                    ? _buildTabletLandscapeContent()
                    : _buildTabletPortraitContent(),
          ),

          SizedBox(height: isLandscape ? 40 : 60),
          const FooterWidget(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildTabletLandscapeContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: const FormSectionWidget(),
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 2,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: const LoginImageWidget(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletPortraitContent() {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: const FormSectionWidget(),
        ),
        const SizedBox(height: 40),
        Container(
          constraints: const BoxConstraints(maxHeight: 250, maxWidth: 350),
          child: const LoginImageWidget(),
        ),
      ],
    );
  }

  // Mobile Layout (< 768px)
  Widget _buildMobileLayout(bool isVerySmall, bool isLandscape) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isVerySmall ? 16.0 : 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: isLandscape ? 20 : 40),

          // Main content container
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: isVerySmall ? 350 : 400),
            margin: EdgeInsets.symmetric(horizontal: isVerySmall ? 8 : 16),
            padding: EdgeInsets.all(isVerySmall ? 16 : 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                isLandscape && !isVerySmall
                    ? _buildMobileLandscapeContent()
                    : _buildMobilePortraitContent(isVerySmall),
          ),

          SizedBox(height: isLandscape ? 20 : 30),

          // Footer with responsive padding
          Container(
            constraints: BoxConstraints(maxWidth: isVerySmall ? 350 : 400),
            child: const FooterWidget(),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMobileLandscapeContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: const FormSectionWidget()),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: const LoginImageWidget(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobilePortraitContent(bool isVerySmall) {
    return Column(
      children: [
        // Form section
        const FormSectionWidget(),

        SizedBox(height: isVerySmall ? 20 : 30),

        // Image section with size constraints
        Container(
          constraints: BoxConstraints(
            maxHeight: isVerySmall ? 180 : 220,
            maxWidth: double.infinity,
          ),
          child: const LoginImageWidget(),
        ),
      ],
    );
  }
}

// Responsive wrapper for form content
class ResponsiveFormWrapper extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveFormWrapper({super.key, required this.child, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;

        return Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? (isMobile ? double.infinity : 500),
          ),
          child: child,
        );
      },
    );
  }
}

// Alternative compact onboarding for very small screens
class CompactOnboardingScreen extends StatelessWidget {
  const CompactOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg-image-png.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Minimal header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Text(
                    'PhillipCapital',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Compact form
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const FormSectionWidget(),
                ),

                const SizedBox(height: 20),
                const FooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
