import 'package:flutter/material.dart';
import 'package:paywize/src/features/transaction/data/models/transaction_model.dart';

class TransactionAmountCard extends StatelessWidget {
  const TransactionAmountCard({required this.transaction, super.key});

  final TransactionModel transaction;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Hero(
              tag: transaction.id,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: transaction.type == TransactionModelType.Income
                      ? Color(0xFF10B981).withOpacity(0.1)
                      : Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  transaction.type == TransactionModelType.Income
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color: transaction.type == TransactionModelType.Income
                      ? Color(0xFF10B981)
                      : Color(0xFFEF4444),
                  size: 40,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '${transaction.amount >= 0 ? '+' : ''}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: transaction.amount >= 0
                    ? Color(0xFF10B981)
                    : Color(0xFFEF4444),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: transaction.type == TransactionModelType.Income
                    ? Color(0xFF10B981).withOpacity(0.1)
                    : Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                transaction.type == TransactionModelType.Income
                    ? 'Income'
                    : 'Expense',
                style: TextStyle(
                  color: transaction.type == TransactionModelType.Income
                      ? Color(0xFF10B981)
                      : Color(0xFFEF4444),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
