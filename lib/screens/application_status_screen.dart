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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: StatusSectionWidget(steps: _steps),
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
