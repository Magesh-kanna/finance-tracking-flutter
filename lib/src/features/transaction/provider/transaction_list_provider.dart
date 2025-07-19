import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paywize/src/features/transaction/data/models/transaction_model.dart';
import 'package:paywize/src/features/transaction/data/models/transaction_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_list_provider.g.dart';

@riverpod
class TransactionList extends _$TransactionList {
  @override
  Future<TransactionState> build() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/transaction_data.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString);
    final transactions = jsonList
        .map((e) => TransactionModel.fromJson(e))
        .toList();
    return TransactionState(
      allTransactions: transactions,
      filteredTransactions: transactions,
      selectedCategory: 'All', // Initialize with default value
      selectedType: TransactionModelType.All,
    );
  }

  double get totalBalance {
    return (state.value?.filteredTransactions ?? []).fold(
      0.0,
      (sum, transaction) => sum + transaction.amount,
    );
  }

  double get totalIncome {
    return (state.value?.filteredTransactions ?? [])
        .where((t) => t.type == TransactionModelType.Income)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpenses {
    return (state.value?.filteredTransactions ?? [])
        .where((t) => t.type == TransactionModelType.Expense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  void search(String query) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(searchQuery: query));
    applyFilters();
  }

  void setCategory(String category) {
    final current = state.value;
    if (current == null) return;
    if (category != '') {
      state = AsyncValue.data(current.copyWith(selectedCategory: category));
      applyFilters();
    }
  }

  void setType(TransactionModelType? type) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(selectedType: type));
    applyFilters();
  }

  void setDateRange(DateTimeRange? range) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(selectedDateRange: range));
    applyFilters();
  }

  void clearFilters() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        selectedCategory: 'All',
        selectedType: null,
        selectedDateRange: null,
        resetDateRange: true,
        resetType: true,
        searchQuery: '',
      ),
    );
    applyFilters();
  }

  void applyFilters() {
    final current = state.value;
    if (current == null) return;

    List<TransactionModel> filtered = current.allTransactions ?? [];

    // Search
    final query = current.searchQuery.toLowerCase();
    if (query != '') {
      filtered = filtered.where((tx) {
        return tx.title.toLowerCase().contains(query) ||
            tx.description.toLowerCase().contains(query) ||
            tx.merchant.toLowerCase().contains(query);
      }).toList();
    }

    // Apply category filter
    final selectedCategory = current.selectedCategory;
    if (selectedCategory != 'All') {
      filtered = filtered
          .where((tx) => tx.category == selectedCategory)
          .toList();
    }

    // Apply type filter
    final selectedType = current.selectedType;
    if (selectedType != null && selectedType != TransactionModelType.All) {
      filtered = filtered.where((tx) => tx.type == selectedType).toList();
    }

    // Apply date range filter
    final dateRange = current.selectedDateRange;
    if (dateRange != null) {
      // Normalize dates to start and end of day for proper comparison
      final startDate = DateTime(
        dateRange.start.year,
        dateRange.start.month,
        dateRange.start.day,
      );
      final endDate = DateTime(
        dateRange.end.year,
        dateRange.end.month,
        dateRange.end.day,
        23,
        59,
        59,
      );

      filtered = filtered.where((tx) {
        return tx.date.isAfter(startDate.subtract(Duration(milliseconds: 1))) &&
            tx.date.isBefore(endDate.add(Duration(milliseconds: 1)));
      }).toList();
    }

    state = AsyncValue.data(current.copyWith(filteredTransactions: filtered));
  }
}
