import 'package:flutter/material.dart';

class TransactionFilterChip extends StatelessWidget {
  const TransactionFilterChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isAction = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isAction
              ? Color(0xFFEF4444).withOpacity(0.1)
              : Color(0xFF667eea).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isAction
                ? Color(0xFFEF4444).withOpacity(0.3)
                : Color(0xFF667eea).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isAction ? Color(0xFFEF4444) : Color(0xFF667eea),
            ),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isAction ? Color(0xFFEF4444) : Color(0xFF667eea),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
