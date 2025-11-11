import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RadioQuestionWidget extends StatelessWidget {
  final String question;
  final bool? value;
  final Function(bool?) onChanged;

  const RadioQuestionWidget({
    Key? key,
    required this.question,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: value,
              onChanged: onChanged,
              activeColor: AppColors.active,
            ),
            const Text(
              'Yes',
              style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
            ),
            const SizedBox(width: 20),
            Radio<bool>(
              value: false,
              groupValue: value,
              onChanged: onChanged,
              activeColor: AppColors.active,
            ),
            const Text(
              'No',
              style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
            ),
          ],
        ),
      ],
    );
  }
}
