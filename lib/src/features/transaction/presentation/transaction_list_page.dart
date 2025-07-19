import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paywize/src/common/utils/slide_animation.dart';
import 'package:paywize/src/features/transaction/data/models/transaction_model.dart';
import 'package:paywize/src/features/transaction/data/models/transaction_state.dart';
import 'package:paywize/src/features/transaction/presentation/widgets/custom_dateranger_picker.dart';
import 'package:paywize/src/features/transaction/presentation/widgets/transaction_card.dart';
import 'package:paywize/src/features/transaction/presentation/widgets/transaction_filter_chip.dart';
import 'package:paywize/src/features/transaction/provider/transaction_list_provider.dart';

class TransactionListPage extends ConsumerStatefulWidget {
  const TransactionListPage({super.key});

  @override
  _TransactionDashboardState createState() => _TransactionDashboardState();
}

class _TransactionDashboardState extends ConsumerState<TransactionListPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _summaryAnimationController;
  late Animation<double> _summaryHeightAnimation;
  late Animation<double> _summaryOpacityAnimation;

  bool _isSummaryVisible = true;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _filterScrollController = ScrollController();
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
  void initState() {
    super.initState();

    _summaryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _summaryHeightAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _summaryAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _summaryOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _summaryAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Add scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _filterScrollController.dispose();
    _summaryAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final currentOffset = _scrollController.offset;

    // Show summary cards only when at the very top (offset <= 5 for small tolerance)
    const topThreshold = 5.0;

    if (currentOffset <= topThreshold) {
      // At the top - show summary cards
      if (!_isSummaryVisible) {
        setState(() {
          _isSummaryVisible = true;
        });
        _summaryAnimationController.reverse();
      }
    } else {
      // Not at the top - hide summary cards
      if (_isSummaryVisible) {
        setState(() {
          _isSummaryVisible = false;
        });
        _summaryAnimationController.forward();
      }
    }
  }

  void scrollToFront() {
    _filterScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _selectDateRange(DateTimeRange? selectedDateRange) async {
    // final DateTimeRange? picked = await showDateRangePicker(
    //   context: context,
    //   firstDate: DateTime.now().subtract(Duration(days: 365)),
    //   lastDate: DateTime.now(),
    //   initialDateRange: selectedDateRange,
    // );
    final DateTimeRange? picked = await _showCustomDateRangePicker(
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
                ref.read(transactionListProvider.notifier).clearFilters();
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
                        AnimatedBuilder(
                          animation: _summaryAnimationController,
                          builder: (context, child) {
                            return SizeTransition(
                              sizeFactor: _summaryHeightAnimation,
                              axisAlignment: 1.0,
                              child: FadeTransition(
                                opacity: _summaryOpacityAnimation,
                                child: SlideAnimation(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      top: 24,
                                      right: 24,
                                      left: 24,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              transactionListNotifier
                                                  .totalBalance,
                                              Icons.account_balance,
                                              Color(0xFF667eea),
                                            ),
                                            SizedBox(width: 12),
                                            _buildSummaryCard(
                                              'Income',
                                              transactionListNotifier
                                                  .totalIncome,
                                              Icons.trending_up,
                                              Color(0xFF10B981),
                                            ),
                                            SizedBox(width: 12),
                                            _buildSummaryCard(
                                              'Expenses',
                                              transactionListNotifier
                                                  .totalExpenses,
                                              Icons.trending_down,
                                              Color(0xFFEF4444),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Filters Section
                        SlideAnimation(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
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
                                  controller: _filterScrollController,
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
                                          scrollToFront();
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
                                      controller: _scrollController,
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
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.purple.shade50],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 50,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Title with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.category_outlined,
                          color: Colors.purple.shade700,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Select Category',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  // Categories list
                  ..._categories.map((category) {
                    bool isSelected =
                        transactionListValue?.selectedCategory == category;
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.purple.shade50
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected
                              ? Colors.purple.shade300
                              : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        title: Text(
                          category,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.purple.shade800
                                : Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          transactionListNotifier.setCategory(category);
                          Navigator.pop(context);
                        },
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.purple.shade600
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                            color: isSelected
                                ? Colors.purple.shade600
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                        trailing: isSelected
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade600,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Selected',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    );
                  }),
                  SizedBox(height: 20),
                ],
              ),
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
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.purple.shade50],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 50,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Title with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.swap_vert,
                          color: Colors.purple.shade700,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Select Type',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  // Type options
                  _buildTypeOption(
                    'All Types',
                    Icons.list_alt,
                    TransactionModelType.All,
                    transactionListValue?.selectedType,
                    transactionListNotifier,
                    context,
                  ),
                  SizedBox(height: 12),
                  _buildTypeOption(
                    'Income',
                    Icons.trending_up,
                    TransactionModelType.Income,
                    transactionListValue?.selectedType,
                    transactionListNotifier,
                    context,
                  ),
                  SizedBox(height: 12),
                  _buildTypeOption(
                    'Expense',
                    Icons.trending_down,
                    TransactionModelType.Expense,
                    transactionListValue?.selectedType,
                    transactionListNotifier,
                    context,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeOption(
    String title,
    IconData icon,
    TransactionModelType? value,
    TransactionModelType? groupValue,
    TransactionList transactionListNotifier,
    BuildContext context,
  ) {
    bool isSelected = groupValue == value;
    Color typeColor = _getTypeColor(value);

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.purple.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? Colors.purple.shade300 : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: Colors.purple.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        onTap: () {
          transactionListNotifier.setType(value);
          Navigator.pop(context);
        },
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: typeColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.purple.shade800 : Colors.grey.shade700,
            fontSize: 16,
          ),
        ),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.purple.shade600 : Colors.grey.shade400,
              width: 2,
            ),
            color: isSelected ? Colors.purple.shade600 : Colors.transparent,
          ),
          child: isSelected
              ? Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
      ),
    );
  }

  Color _getTypeColor(TransactionModelType? type) {
    switch (type) {
      case TransactionModelType.Income:
        return Colors.green.shade600;
      case TransactionModelType.Expense:
        return Colors.red.shade600;
      default:
        return Colors.purple.shade600;
    }
  }

  Future<DateTimeRange?> _showCustomDateRangePicker({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTimeRange? initialDateRange,
  }) async {
    return await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomDateRangePicker(
        firstDate: firstDate,
        lastDate: lastDate,
        initialDateRange: initialDateRange,
      ),
    );
  }

  // void _showCategoryFilter(
  //   TransactionState? transactionListValue,
  //   TransactionList transactionListNotifier,
  // ) {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(28.0),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 'Select Category',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF2D3748),
  //                 ),
  //               ),
  //               SizedBox(height: 20),
  //               ..._categories.map((category) {
  //                 return ListTile(
  //                   title: Text(category),
  //                   leading: Radio<String>(
  //                     value: category,
  //                     groupValue: transactionListValue?.selectedCategory,
  //                     onChanged: (value) {
  //                       transactionListNotifier.setCategory(value ?? '');
  //                       Navigator.pop(context);
  //                     },
  //                   ),
  //                 );
  //               }),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // void _showTypeFilter(
  //   TransactionState? transactionListValue,
  //   TransactionList transactionListNotifier,
  // ) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         padding: EdgeInsets.all(20),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               'Select Type',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xFF2D3748),
  //               ),
  //             ),
  //             SizedBox(height: 20),
  //             ListTile(
  //               title: Text('All Types'),
  //               leading: Radio<TransactionModelType?>(
  //                 value: null,
  //                 groupValue: transactionListValue?.selectedType,
  //                 onChanged: (value) {
  //                   transactionListNotifier.setType(value);
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ),
  //             ListTile(
  //               title: Text('Income'),
  //               leading: Radio<TransactionModelType?>(
  //                 value: TransactionModelType.Income,
  //                 groupValue: transactionListValue?.selectedType,
  //                 onChanged: (value) {
  //                   transactionListNotifier.setType(value);
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ),
  //             ListTile(
  //               title: Text('Expense'),
  //               leading: Radio<TransactionModelType?>(
  //                 value: TransactionModelType.Expense,
  //                 groupValue: transactionListValue?.selectedType,
  //                 onChanged: (value) {
  //                   transactionListNotifier.setType(value);
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
