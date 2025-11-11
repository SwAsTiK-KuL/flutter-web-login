import 'package:flutter/material.dart';
import 'package:philip_capital_india/widgets/email_header_widget.dart';
import 'package:philip_capital_india/widgets/phone_footer_widget.dart';
import '../widgets/email_section_widget.dart';
import '../widgets/login_image_widget.dart';

class PhillipCapitalEmailScreen extends StatelessWidget {
  const PhillipCapitalEmailScreen({Key? key}) : super(key: key);

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
              const OnboardingHeaderWidget(),
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
    return const Column(
      children: [
        EmailSectionWidget(),
        SizedBox(height: 30),
        LoginImageWidget(),
      ],
    );
  }

  // Tablet Layout: Side by side with balanced spacing
  Widget _buildTabletLayout() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: EmailSectionWidget()),
        SizedBox(width: 40),
        Expanded(child: LoginImageWidget()),
      ],
    );
  }

  // Desktop Layout: Side by side with extra spacing
  Widget _buildDesktopLayout() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 150),
        Expanded(flex: 1, child: EmailSectionWidget()),
        SizedBox(width: 60),
        Expanded(flex: 1, child: LoginImageWidget()),
      ],
    );
  }
}

// Alternative implementation using LayoutBuilder
class PhillipCapitalEmailScreenAlt extends StatelessWidget {
  const PhillipCapitalEmailScreenAlt({Key? key}) : super(key: key);

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
              const OnboardingHeaderWidget(),
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
              ? const Column(
                children: [
                  EmailSectionWidget(),
                  SizedBox(height: 30),
                  LoginImageWidget(),
                ],
              )
              : Row(
                crossAxisAlignment:
                    isTablet
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                children: [
                  if (!isTablet) const SizedBox(width: 150),
                  const Expanded(flex: 1, child: EmailSectionWidget()),
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
