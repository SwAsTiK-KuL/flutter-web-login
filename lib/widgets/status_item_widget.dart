import 'package:flutter/material.dart';

class StatusItemWidget extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final IconData icon;
  final bool isLast;

  const StatusItemWidget({
    Key? key,
    required this.title,
    required this.date,
    required this.status,
    required this.icon,
    required this.isLast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define colors based on status
    Color statusColor;
    Color textColor;

    switch (status) {
      case 'completed':
        statusColor = const Color(0xFF10B981); // Green
        textColor = const Color(0xFF10B981);
        break;
      case 'in_progress':
        statusColor = const Color(0xFFFB9E00); // Orange
        textColor = const Color(0xFFFB9E00);
        break;
      case 'pending':
      default:
        statusColor = const Color(0xFFE5E7EB); // Grey
        textColor = const Color(0xFF9CA3AF);
        break;
    }

    final bool isPending = status == 'pending';
    final bool isCompleted = status == 'completed';

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Column with line below
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  // Status Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor,
                      border:
                          isPending
                              ? Border.all(
                                color: const Color(0xFFE5E7EB),
                                width: 2,
                              )
                              : null,
                    ),
                    child: Icon(
                      icon,
                      color: isPending ? const Color(0xFF9CA3AF) : Colors.white,
                      size: 20,
                    ),
                  ),

                  // Vertical line below icon
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color:
                            isCompleted
                                ? const Color(0xFF10B981)
                                : const Color(0xFFE5E7EB),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // Status Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            isPending
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(fontSize: 12, color: textColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Spacing between items
        if (!isLast) const SizedBox(height: 12),
      ],
    );
  }
}
