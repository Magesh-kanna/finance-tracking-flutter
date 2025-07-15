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
    );
  }

  double get totalBalance {
    return (state.value?.filteredTransactions ?? []).fold(
      0.0,
      (sum, transaction) => (sum ?? 0) + transaction.amount,
    );
  }

  double get totalIncome {
    return (state.value?.filteredTransactions ?? [])
        .where((t) => t.type == TransactionModelType.income)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpenses {
    return (state.value?.filteredTransactions ?? [])
        .where((t) => t.type == TransactionModelType.expense)
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
        searchQuery: '',
      ),
    );
    applyFilters();
  }

  void applyFilters() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(searchQuery: state.value?.searchQuery ?? ''),
    );
    List<TransactionModel> filtered = state.value?.allTransactions ?? [];

    // Search
    final query = state.value?.searchQuery.toLowerCase() ?? '';
    if (query != '') {
      filtered = filtered.where((tx) {
        return tx.title.toLowerCase().contains(query) ||
            tx.description.toLowerCase().contains(query) ||
            tx.merchant.toLowerCase().contains(query);
      }).toList();
    }

    // Category
    if (state.value?.selectedCategory != 'All') {
      filtered = filtered
          .where((tx) => tx.category == state.value?.selectedCategory)
          .toList();
    }

    // Type
    if (state.value?.selectedType != null) {
      filtered = filtered
          .where((tx) => tx.type == state.value?.selectedType)
          .toList();
    }

    // Date Range
    if (state.value != null && state.value?.selectedDateRange != null) {
      filtered = filtered.where((tx) {
        return tx.date.isAfter(
              state.value!.selectedDateRange!.start.subtract(Duration(days: 1)),
            ) &&
            tx.date.isBefore(
              state.value!.selectedDateRange!.end.add(Duration(days: 1)),
            );
      }).toList();
    }

    state = AsyncValue.data(current.copyWith(filteredTransactions: filtered));
  }
}
