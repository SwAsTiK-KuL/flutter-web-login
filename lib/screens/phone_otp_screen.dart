import 'package:flutter/material.dart';
import 'package:philip_capital_india/widgets/header_widget.dart';
import 'package:philip_capital_india/widgets/phone_footer_widget.dart';
import 'package:philip_capital_india/widgets/phone_otp_section.dart';
import 'package:philip_capital_india/widgets/login_image_widget.dart';

class PhillipCapitalOTPScreen extends StatelessWidget {
  final String phoneNumber;
  const PhillipCapitalOTPScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('bg-image-png.png'),
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
    final size = MediaQuery.of(context).size;
    final width = size.width;

    // Define breakpoints
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;
    final isDesktop = width >= 1024;

    // Responsive padding
    final horizontalPadding =
        isMobile
            ? 16.0
            : isTablet
            ? 40.0
            : 80.0;

    // Responsive top spacing
    final topSpacing =
        isMobile
            ? 30.0
            : isTablet
            ? 50.0
            : 80.0;

    // Responsive bottom spacing
    final bottomSpacing =
        isMobile
            ? 30.0
            : isTablet
            ? 40.0
            : 60.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: topSpacing),
          if (isMobile) _buildMobileLayout(),
          if (isTablet) _buildTabletLayout(),
          if (isDesktop) _buildDesktopLayout(),
          SizedBox(height: bottomSpacing),
          const FooterWidget(),
        ],
      ),
    );
  }

  // Mobile Layout: Stacked vertically
  Widget _buildMobileLayout() {
    return Column(
      children: [
        OTPSectionWidget(phoneNumber: phoneNumber),
        const SizedBox(height: 30),
        const LoginImageWidget(),
      ],
    );
  }

  // Tablet Layout: Side by side with balanced spacing
  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: OTPSectionWidget(phoneNumber: phoneNumber)),
        const SizedBox(width: 40),
        const Expanded(child: LoginImageWidget()),
      ],
    );
  }

  // Desktop Layout: Side by side with extra spacing
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 120),
        Expanded(flex: 1, child: OTPSectionWidget(phoneNumber: phoneNumber)),
        const SizedBox(width: 60),
        const Expanded(flex: 1, child: LoginImageWidget()),
      ],
    );
  }
}

// Alternative implementation using LayoutBuilder for more granular control
class PhillipCapitalOTPScreenAlt extends StatelessWidget {
  final String phoneNumber;
  const PhillipCapitalOTPScreenAlt({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('bg-image-png.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const HeaderWidget(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: _buildResponsiveLayout(constraints),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    final horizontalPadding =
        isMobile
            ? 16.0
            : isTablet
            ? 40.0
            : 80.0;
    final topSpacing =
        isMobile
            ? 30.0
            : isTablet
            ? 50.0
            : 80.0;
    final bottomSpacing =
        isMobile
            ? 30.0
            : isTablet
            ? 40.0
            : 60.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: topSpacing),
          isMobile
              ? Column(
                children: [
                  OTPSectionWidget(phoneNumber: phoneNumber),
                  const SizedBox(height: 30),
                  const LoginImageWidget(),
                ],
              )
              : Row(
                crossAxisAlignment:
                    isTablet
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                children: [
                  if (!isTablet) const SizedBox(width: 120),
                  Expanded(
                    flex: 1,
                    child: OTPSectionWidget(phoneNumber: phoneNumber),
                  ),
                  SizedBox(width: isTablet ? 40 : 60),
                  const Expanded(flex: 1, child: LoginImageWidget()),
                ],
              ),
          SizedBox(height: bottomSpacing),
          const FooterWidget(),
        ],
      ),
    );
  }
}
