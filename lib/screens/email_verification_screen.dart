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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(width: 150),
                            Expanded(flex: 1, child: EmailSectionWidget()),
                            Expanded(flex: 1, child: LoginImageWidget()),
                          ],
                        ),
                        const SizedBox(height: 60),
                        const FooterWidget(),
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
