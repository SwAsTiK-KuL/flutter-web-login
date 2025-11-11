import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _footerText('CIN: U92A03MH1983PTC123356'),
          const SizedBox(height: 4),
          _footerText(
            'SEBI Registration Nos: Stock Broker: INZ000169536 (NSE, MCEX, BSE-418, MSEI-0604)',
          ),
          const SizedBox(height: 4),
          _footerText(
            'MCX-50050/B051 and NCDEX - 01255) Depository Participant - IN-DP-516-2020 (NSDL & CDSL)',
          ),
        ],
      ),
    );
  }

  Widget _footerText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
      textAlign: TextAlign.center,
    );
  }
}
