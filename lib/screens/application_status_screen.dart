import 'package:flutter/material.dart';
import 'package:philip_capital_india/widgets/email_header_widget.dart';
import 'package:philip_capital_india/widgets/status_section_widget.dart';

class PhillipCapitalApplicationStatusScreen extends StatefulWidget {
  const PhillipCapitalApplicationStatusScreen({Key? key}) : super(key: key);

  @override
  State<PhillipCapitalApplicationStatusScreen> createState() =>
      _PhillipCapitalApplicationStatusScreenState();
}

class _PhillipCapitalApplicationStatusScreenState
    extends State<PhillipCapitalApplicationStatusScreen> {
  late final List<Map<String, dynamic>> _steps;

  @override
  void initState() {
    super.initState();
    _steps = _buildStatusSteps();
  }

  List<Map<String, dynamic>> _buildStatusSteps() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfter = today.add(const Duration(days: 2));

    String formatDate(DateTime date) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
    }

    return [
      {
        'title': 'Application Submitted',
        'date': formatDate(today),
        'status': 'completed',
        'icon': Icons.check_circle,
      },
      {
        'title': 'Application Under Review',
        'date': formatDate(today),
        'status': 'completed',
        'icon': Icons.check_circle,
      },
      {
        'title': 'Account Activation in Progress',
        'date': formatDate(tomorrow),
        'status': 'in_progress',
        'icon': Icons.access_time,
      },
      {
        'title': 'Account Ready to Use',
        'date': formatDate(dayAfter),
        'status': 'pending',
        'icon': Icons.access_time,
      },
    ];
  }

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

    // Content max width for better readability on large screens
    final contentMaxWidth = isDesktop ? 1200.0 : double.infinity;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: topSpacing),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: StatusSectionWidget(steps: _steps),
            ),
          ),
          SizedBox(height: bottomSpacing),
        ],
      ),
    );
  }
}

// Alternative implementation with LayoutBuilder and centered content
class PhillipCapitalApplicationStatusScreenAlt extends StatefulWidget {
  const PhillipCapitalApplicationStatusScreenAlt({Key? key}) : super(key: key);

  @override
  State<PhillipCapitalApplicationStatusScreenAlt> createState() =>
      _PhillipCapitalApplicationStatusScreenAltState();
}

class _PhillipCapitalApplicationStatusScreenAltState
    extends State<PhillipCapitalApplicationStatusScreenAlt> {
  late final List<Map<String, dynamic>> _steps;

  @override
  void initState() {
    super.initState();
    _steps = _buildStatusSteps();
  }

  List<Map<String, dynamic>> _buildStatusSteps() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfter = today.add(const Duration(days: 2));

    String formatDate(DateTime date) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
    }

    return [
      {
        'title': 'Application Submitted',
        'date': formatDate(today),
        'status': 'completed',
        'icon': Icons.check_circle,
      },
      {
        'title': 'Application Under Review',
        'date': formatDate(today),
        'status': 'completed',
        'icon': Icons.check_circle,
      },
      {
        'title': 'Account Activation in Progress',
        'date': formatDate(tomorrow),
        'status': 'in_progress',
        'icon': Icons.access_time,
      },
      {
        'title': 'Account Ready to Use',
        'date': formatDate(dayAfter),
        'status': 'pending',
        'icon': Icons.access_time,
      },
    ];
  }

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
    final isDesktop = width >= 1024;

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

    // Center content with max width on desktop for better UX
    final contentMaxWidth = isDesktop ? 1200.0 : double.infinity;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: topSpacing),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: StatusSectionWidget(steps: _steps),
            ),
          ),
          SizedBox(height: bottomSpacing),
        ],
      ),
    );
  }
}
