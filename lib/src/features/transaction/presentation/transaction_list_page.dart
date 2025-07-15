import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paywize/src/common/utils/slide_animation.dart';
import 'package:paywize/src/features/transaction/data/models/transaction_model.dart';
import 'package:paywize/src/features/transaction/data/models/transaction_state.dart';
import 'package:paywize/src/features/transaction/presentation/widgets/transaction_card.dart';
import 'package:paywize/src/features/transaction/presentation/widgets/transaction_filter_chip.dart';
import 'package:paywize/src/features/transaction/provider/transaction_list_provider.dart';

class TransactionListPage extends ConsumerStatefulWidget {
  const TransactionListPage({super.key});

  @override
  _TransactionDashboardState createState() => _TransactionDashboardState();
}

class _TransactionDashboardState extends ConsumerState<TransactionListPage> {
  final TextEditingController _searchController = TextEditingController();

  // Mock categories for filtering
  final List<String> _categories = [
    'All',
    'Food & Dining',
    'Shopping',
    'Transportation',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Other',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange(DateTimeRange? selectedDateRange) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange,
    );

    if (picked != null) {
      ref.read(transactionListProvider.notifier).setDateRange(picked);
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(Icons.search, color: Color(0xFF667eea)),
      suffixIcon: _searchController.text.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.clear, color: Color(0xFF667eea)),
              onPressed: () {
                _searchController.clear();
                ref.read(transactionListProvider.notifier).search('');
              },
            )
          : null,
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(color: Color(0xFF667eea).withOpacity(0.7)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Color(0xFF667eea).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFF667eea), width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionListValue = ref.watch(transactionListProvider).value;
    final transactionListNotifier = ref.watch(transactionListProvider.notifier);
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
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Transactions',
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
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
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
                    child: Column(
                      children: [
                        // Summary Cards
                        SlideAnimation(
                          child: Container(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Financial Overview',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    _buildSummaryCard(
                                      'Balance',
                                      transactionListNotifier.totalBalance,
                                      Icons.account_balance,
                                      Color(0xFF667eea),
                                    ),
                                    SizedBox(width: 12),
                                    _buildSummaryCard(
                                      'Income',
                                      transactionListNotifier.totalIncome,
                                      Icons.trending_up,
                                      Color(0xFF10B981),
                                    ),
                                    SizedBox(width: 12),
                                    _buildSummaryCard(
                                      'Expenses',
                                      transactionListNotifier.totalExpenses,
                                      Icons.trending_down,
                                      Color(0xFFEF4444),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Filters Section
                        SlideAnimation(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Search & Filter test
                                Text(
                                  'Search & Filter',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Search Bar
                                TextField(
                                  controller: _searchController,
                                  decoration: _inputDecoration(
                                    'Search transactions...',
                                  ),
                                  onChanged: (value) {
                                    transactionListNotifier.search(value);
                                  },
                                  onSubmitted: (value) {
                                    transactionListNotifier.search(value);
                                  },
                                ),
                                SizedBox(height: 16),

                                // Filter Chips
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    spacing: 8,
                                    children: [
                                      TransactionFilterChip(
                                        label:
                                            'Category: ${transactionListValue?.selectedCategory}',
                                        icon: Icons.category,
                                        onTap: () => _showCategoryFilter(
                                          transactionListValue,
                                          transactionListNotifier,
                                        ),
                                      ),
                                      TransactionFilterChip(
                                        label:
                                            transactionListValue
                                                    ?.selectedType ==
                                                null
                                            ? 'Type: All'
                                            : 'Type: ${transactionListValue?.selectedType.toString().split('.').last}',
                                        icon: Icons.swap_horiz,
                                        onTap: () => _showTypeFilter(
                                          transactionListValue,
                                          transactionListNotifier,
                                        ),
                                      ),
                                      TransactionFilterChip(
                                        label:
                                            transactionListValue
                                                    ?.selectedDateRange ==
                                                null
                                            ? 'Date Range'
                                            : 'Date: ${transactionListValue?.selectedDateRange!.start.day}/${transactionListValue?.selectedDateRange!.start.month} - ${transactionListValue?.selectedDateRange!.end.day}/${transactionListValue?.selectedDateRange!.end.month}',
                                        icon: Icons.date_range,
                                        onTap: () => _selectDateRange(
                                          transactionListValue
                                              ?.selectedDateRange,
                                        ),
                                      ),
                                      TransactionFilterChip(
                                        label: 'Clear',
                                        icon: Icons.clear,
                                        onTap: () {
                                          _searchController.clear();
                                          transactionListNotifier
                                              .clearFilters();
                                        },
                                        isAction: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 24),

                        // Transactions List
                        Expanded(
                          child:
                              (transactionListValue?.filteredTransactions ?? [])
                                  .isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 60,
                                        color: Color(
                                          0xFF667eea,
                                        ).withOpacity(0.5),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No transactions found',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF718096),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SlideAnimation(
                                  child: RefreshIndicator(
                                    onRefresh: () async =>
                                        ref.invalidate(transactionListProvider),
                                    color: Color(0xFF667eea),
                                    child: ListView.builder(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      itemCount:
                                          (transactionListValue
                                                      ?.filteredTransactions ??
                                                  [])
                                              .length,
                                      itemBuilder: (context, index) {
                                        final transaction =
                                            (transactionListValue
                                                ?.filteredTransactions ??
                                            [])[index];
                                        return TransactionCard(
                                          transaction: transaction,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        ),
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

  Widget _buildSummaryCard(
    String title,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            FittedBox(
              child: Text(
                '\$${amount.abs().toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryFilter(
    TransactionState? transactionListValue,
    TransactionList transactionListNotifier,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(28.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 20),
                ..._categories.map((category) {
                  return ListTile(
                    title: Text(category),
                    leading: Radio<String>(
                      value: category,
                      groupValue: transactionListValue?.selectedCategory,
                      onChanged: (value) {
                        transactionListNotifier.setCategory(value ?? '');
                        Navigator.pop(context);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTypeFilter(
    TransactionState? transactionListValue,
    TransactionList transactionListNotifier,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('All Types'),
                leading: Radio<TransactionModelType?>(
                  value: null,
                  groupValue: transactionListValue?.selectedType,
                  onChanged: (value) {
                    transactionListNotifier.setType(value);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text('Income'),
                leading: Radio<TransactionModelType?>(
                  value: TransactionModelType.income,
                  groupValue: transactionListValue?.selectedType,
                  onChanged: (value) {
                    transactionListNotifier.setType(value);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text('Expense'),
                leading: Radio<TransactionModelType?>(
                  value: TransactionModelType.expense,
                  groupValue: transactionListValue?.selectedType,
                  onChanged: (value) {
                    transactionListNotifier.setType(value);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
