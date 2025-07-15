// transaction_state.dart
import 'package:flutter/material.dart';

import 'transaction_model.dart';

class TransactionState {
  final List<TransactionModel>? allTransactions;
  final List<TransactionModel>? filteredTransactions;
  final String searchQuery;
  final String selectedCategory;
  final TransactionModelType? selectedType;
  final DateTimeRange? selectedDateRange;

  TransactionState({
    this.allTransactions,
    this.filteredTransactions,
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.selectedType,
    this.selectedDateRange,
  });

  TransactionState copyWith({
    List<TransactionModel>? allTransactions,
    List<TransactionModel>? filteredTransactions,
    String? searchQuery,
    String? selectedCategory,
    TransactionModelType? selectedType,
    DateTimeRange? selectedDateRange,
    bool resetType = false,
    bool resetDateRange = false,
  }) {
    return TransactionState(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedType: resetType ? null : selectedType ?? this.selectedType,
      selectedDateRange: resetDateRange
          ? null
          : selectedDateRange ?? this.selectedDateRange,
    );
  }
}
