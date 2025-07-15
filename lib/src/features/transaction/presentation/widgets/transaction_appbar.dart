import 'package:flutter/material.dart';

class TransactionAppbar extends StatelessWidget {
  const TransactionAppbar({
    required this.appBarTitle,
    required this.trailingIcon,
    super.key,
  });

  final String appBarTitle;
  final IconData trailingIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              appBarTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(trailingIcon, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
