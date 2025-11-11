import 'package:flutter/material.dart';
import 'status_item_widget.dart';

class StatusSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> steps;

  const StatusSectionWidget({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(40.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Application Status',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            Column(
              children:
                  steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    final isLast = index == steps.length - 1;

                    return StatusItemWidget(
                      title: step['title'],
                      date: step['date'],
                      status: step['status'],
                      icon: step['icon'],
                      isLast: isLast,
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
