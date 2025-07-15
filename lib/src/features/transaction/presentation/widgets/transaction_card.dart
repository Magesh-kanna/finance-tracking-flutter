import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paywize/src/features/transaction/data/models/transaction_model.dart';
import 'package:paywize/src/features/transaction/presentation/transaction_detail_page.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({required this.transaction, super.key});

  final TransactionModel transaction;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) =>
                TransactionDetailPage(transaction: transaction),
          ),
        ),
        contentPadding: EdgeInsets.all(16),
        leading: Hero(
          tag: transaction.id,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: transaction.type == TransactionModelType.income
                  ? Color(0xFF10B981).withOpacity(0.1)
                  : Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.type == TransactionModelType.income
                  ? Icons.trending_up
                  : Icons.trending_down,
              color: transaction.type == TransactionModelType.income
                  ? Color(0xFF10B981)
                  : Color(0xFFEF4444),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF2D3748),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              transaction.description,
              style: TextStyle(color: Color(0xFF718096), fontSize: 14),
            ),

            /// Commented out the merchant and category text fields
            /// - since its taking too much space on card to show
            // SizedBox(height: 8),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     FittedBox(
            //       child: Row(
            //         children: [
            //           Icon(Icons.store, size: 14, color: Color(0xFF667eea)),
            //           SizedBox(width: 4),
            //           Text(
            //             transaction.merchant,
            //             style: TextStyle(
            //               fontSize: 12,
            //               color: Color(0xFF667eea),
            //               fontWeight: FontWeight.w500,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     const SizedBox(height: 4),
            //     FittedBox(
            //       child: Row(
            //         children: [
            //           Icon(Icons.category, size: 14, color: Color(0xFF667eea)),
            //           SizedBox(width: 4),
            //           Text(
            //             transaction.category,
            //             style: TextStyle(
            //               fontSize: 12,
            //               color: Color(0xFF667eea),
            //               fontWeight: FontWeight.w500,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.amount >= 0 ? '+' : ''}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: transaction.amount >= 0
                    ? Color(0xFF10B981)
                    : Color(0xFFEF4444),
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
              style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
            ),
          ],
        ),
      ),
    );
  }
}
