import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paywize/src/common/utils/slide_animation.dart';
import 'package:paywize/src/features/transaction/data/models/transaction_model.dart';
import 'package:paywize/src/features/transaction/presentation/widgets/transaction_action_buttons.dart';
import 'package:paywize/src/features/transaction/presentation/widgets/transaction_amount_card.dart';
import 'package:paywize/src/features/transaction/presentation/widgets/transaction_appbar.dart';
import 'package:paywize/src/features/transaction/presentation/widgets/transaction_detail_info_card.dart';

class TransactionDetailPage extends ConsumerStatefulWidget {
  final TransactionModel transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends ConsumerState<TransactionDetailPage> {
  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Custom App Bar
              TransactionAppbar(
                appBarTitle: 'Transaction Details',
                trailingIcon: Icons.receipt_long,
              ),
              // Main Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Transaction Amount Card
                          SlideAnimation(
                            child: TransactionAmountCard(
                              transaction: transaction,
                            ),
                          ),

                          // Transaction Info Cards
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Heading
                                Text(
                                  'Transaction Information',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Title & Description Card
                                SlideAnimation(
                                  child: TransactionDetailInfoCard(
                                    title: 'Transaction Details',
                                    children: [
                                      _buildInfoRow(
                                        Icons.title,
                                        'Title',
                                        transaction.title,
                                      ),
                                      _buildInfoRow(
                                        Icons.description,
                                        'Description',
                                        transaction.description,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 16),

                                // Category & Merchant Card
                                SlideAnimation(
                                  child: TransactionDetailInfoCard(
                                    title: 'Business Information',
                                    children: [
                                      _buildInfoRow(
                                        Icons.category,
                                        'Category',
                                        transaction.category,
                                      ),
                                      _buildInfoRow(
                                        Icons.store,
                                        'Merchant',
                                        transaction.merchant,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 16),

                                // Date & Time Card
                                SlideAnimation(
                                  child: TransactionDetailInfoCard(
                                    title: 'Date & Time',
                                    children: [
                                      _buildInfoRow(
                                        Icons.calendar_today,
                                        'Date',
                                        '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                                      ),
                                      _buildInfoRow(
                                        Icons.access_time,
                                        'Time',
                                        '${transaction.date.hour.toString().padLeft(2, '0')}:${transaction.date.minute.toString().padLeft(2, '0')}',
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 24),

                                // Action Buttons
                                SlideAnimation(child: _buildActionButtons()),

                                SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF667eea).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFF667eea), size: 16),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2D3748),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TransactionActionButtons(
            label: 'Edit',
            icon: Icons.edit,
            color: Color(0xFF667eea),
            onPressed: () {
              // Navigate to edit transaction page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Edit transaction feature coming soon!'),
                  backgroundColor: Color(0xFF667eea),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: TransactionActionButtons(
            label: 'Delete',
            icon: Icons.delete,
            color: Color(0xFFEF4444),
            onPressed: () {
              _showDeleteConfirmation();
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Transaction',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          content: Text(
            'Are you sure you want to delete this transaction? This action cannot be undone.',
            style: TextStyle(color: Color(0xFF718096)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Color(0xFF718096))),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Transaction deleted successfully!'),
                    backgroundColor: Color(0xFFEF4444),
                  ),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
