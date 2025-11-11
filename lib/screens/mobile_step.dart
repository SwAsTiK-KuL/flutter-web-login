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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(width: 150),
                            Expanded(flex: 1, child: FormSectionWidget()),
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
