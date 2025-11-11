import 'package:flutter/material.dart';
import 'package:philip_capital_india/utils/constants.dart';
import 'package:philip_capital_india/widgets/email_header_widget.dart';
import 'package:philip_capital_india/widgets/form_field_widget.dart';
import 'package:philip_capital_india/widgets/progress_sidebar_widget.dart';
import 'package:philip_capital_india/widgets/radio_question_widget.dart';
import 'application_status_screen.dart';

class PhillipCapitalAdditionalDetailsScreen extends StatefulWidget {
  const PhillipCapitalAdditionalDetailsScreen({super.key});

  @override
  State<PhillipCapitalAdditionalDetailsScreen> createState() =>
      _PhillipCapitalAdditionalDetailsScreenState();
}

class _PhillipCapitalAdditionalDetailsScreenState
    extends State<PhillipCapitalAdditionalDetailsScreen> {
  final _workProfileController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _experienceController = TextEditingController();
  final _incomeController = TextEditingController();
  final _netWorthController = TextEditingController();
  final _educationController = TextEditingController();
  final _tradingExperienceController = TextEditingController();
  final _accountSettlementController = TextEditingController();

  String? _selectedOccupationType;
  String? _selectedOrderPlacer;
  String? _selectedIncomeRange;
  String? _selectedTradingExperience;
  String? _selectedAccountSettlement;
  bool? _dealingWithOtherBroker;
  bool? _electronicContractNote;

  final _occupationTypes = [
    'Private Service',
    'Government Service',
    'Self Employed',
    'Business',
    'Professional',
    'Retired',
    'Housewife',
    'Student',
    'Others',
  ];

  final _incomeRanges = [
    'Below 1 Lakh',
    '1-5 Lakhs',
    '5-10 Lakhs',
    '10-25 Lakhs',
    '25-50 Lakhs',
    'Above 50 Lakhs',
  ];

  final _tradingExperiences = [
    'No Experience',
    'Less than 1 Year',
    '1-3 Years',
    '3-5 Years',
    'More than 5 Years',
  ];

  final _accountSettlements = ['Express', 'Normal', 'Running Account'];
  final _orderPlacers = [
    'Self',
    'Authorized Person',
    'Family Member',
    'Others',
  ];

  @override
  void dispose() {
    _workProfileController.dispose();
    _companyNameController.dispose();
    _addressController.dispose();
    _experienceController.dispose();
    _incomeController.dispose();
    _netWorthController.dispose();
    _educationController.dispose();
    _tradingExperienceController.dispose();
    _accountSettlementController.dispose();
    super.dispose();
  }

  void _proceedToNext() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Additional details submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const PhillipCapitalApplicationStatusScreen(),
      ),
    );
  }

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
              // Header with white background
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                child: const OnboardingHeaderWidget(),
              ),
              Expanded(
                child: Row(
                  children: [
                    const ProgressSidebarWidget(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(40.0),
                        child: _buildFormContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        padding: const EdgeInsets.all(40.0),
        margin: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Details',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please provide accurate information for account verification',
              style: TextStyle(fontSize: 14, color: AppColors.textGray),
            ),
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column
                Expanded(
                  child: Column(
                    children: [
                      AppDropdownField(
                        label: 'Occupation Type',
                        hint: 'Select',
                        items: _occupationTypes,
                        value: _selectedOccupationType,
                        onChanged:
                            (v) => setState(() => _selectedOccupationType = v),
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'Name of Company/Business',
                        hint: 'Enter company name',
                        controller: _companyNameController,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'Years of Experience',
                        hint: 'e.g. 5',
                        controller: _experienceController,
                      ),
                      const SizedBox(height: 20),
                      AppDropdownField(
                        label: 'Income Range',
                        hint: 'Select range',
                        items: _incomeRanges,
                        value: _selectedIncomeRange,
                        onChanged:
                            (v) => setState(() => _selectedIncomeRange = v),
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'Educational Qualification',
                        hint: 'e.g. B.Tech',
                        controller: _educationController,
                      ),
                      const SizedBox(height: 20),
                      AppDropdownField(
                        label: 'Preference for running Account Settlement',
                        hint: 'Select',
                        items: _accountSettlements,
                        value: _selectedAccountSettlement,
                        onChanged:
                            (v) =>
                                setState(() => _selectedAccountSettlement = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                // Right Column
                Expanded(
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'Work Profile',
                        hint: 'e.g. Software Engineer',
                        controller: _workProfileController,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'Address of Occupation',
                        hint: 'Enter address',
                        controller: _addressController,
                      ),
                      const SizedBox(height: 20),
                      AppDropdownField(
                        label: 'Who will place the Order',
                        hint: 'Select',
                        items: _orderPlacers,
                        value: _selectedOrderPlacer,
                        onChanged:
                            (v) => setState(() => _selectedOrderPlacer = v),
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'Net Worth',
                        hint: 'e.g. 10 Lakhs',
                        controller: _netWorthController,
                      ),
                      const SizedBox(height: 20),
                      AppDropdownField(
                        label: 'Trading/Investment Experience',
                        hint: 'Select',
                        items: _tradingExperiences,
                        value: _selectedTradingExperience,
                        onChanged:
                            (v) =>
                                setState(() => _selectedTradingExperience = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: RadioQuestionWidget(
                    question: 'Dealing with any other Broker?',
                    value: _dealingWithOtherBroker,
                    onChanged:
                        (v) => setState(() => _dealingWithOtherBroker = v),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: RadioQuestionWidget(
                    question: 'Electronic Contract Note(ECN)',
                    value: _electronicContractNote,
                    onChanged:
                        (v) => setState(() => _electronicContractNote = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Center(
              child: SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: _proceedToNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Proceed',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
