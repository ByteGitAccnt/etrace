import 'dart:async';

import 'package:etrace/Api/DeleteService.dart';
import 'package:etrace/Api/FetchService.dart';
import 'package:etrace/Model/Expense.dart';
import 'package:etrace/Model/Transaction.dart';
import 'package:etrace/Notifiers/transaction/TransactionState.dart';
import 'package:etrace/Utils/mapCategoryToIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier() : super(TransactionState.initial());

  Timer? _undoTimer;

  // =======================================================
  // LOAD EXPENSES (cached + filters + refresh)
  // =======================================================
  Future<void> loadExpenses({
    String? fromDate,
    String? toDate,
    int? category,
    bool forceRefresh = false,
  }) async {
    final filtersChanged =
        state.expenseFromDate != fromDate ||
        state.expenseToDate != toDate ||
        state.expenseCategory != category;

    if (state.expensesLoaded && !forceRefresh && !filtersChanged) return;

    state = state.copyWith(
      isLoadingExpenses: true,
      expensePage: 0,
      expenseItems: [],
      expenseHasMore: true,

      expenseFromDate: fromDate,
      expenseToDate: toDate,
      expenseCategory: category,

      error: null,
    );

    try {
      final data = await _fetchExpenses(fromDate, toDate, category, page: 0);

      state = state.copyWith(
        expenseItems: data,
        isLoadingExpenses: false,
        expensesLoaded: true,
        expensePage: 0,
        expenseHasMore: data.length == 10,
      );
    } catch (e) {
      state = state.copyWith(isLoadingExpenses: false, error: e.toString());
    }
  }

  // =======================================================
  // LOAD RESERVES
  // =======================================================
  Future<void> loadReserves({bool forceRefresh = false}) async {
    if (state.reservesLoaded && !forceRefresh) return;

    state = state.copyWith(isLoadingReserves: true, error: null);

    try {
      final reserves = await FetchService().fetchReserves();

      final data = reserves
          .map(
            (r) => Transaction(
              id: r.id,
              title: r.label,
              amount: r.amount,
              date: "N/A",
              icon: Icons.account_balance_wallet,
              isExpense: false,
            ),
          )
          .toList();

      state = state.copyWith(
        reserveItems: data,
        isLoadingReserves: false,
        reservesLoaded: true,
      );
    } catch (e) {
      state = state.copyWith(isLoadingReserves: false, error: e.toString());
    }
  }

  // =======================================================
  // PAGINATION (EXPENSES ONLY)
  // =======================================================
  Future<void> fetchMoreExpenses() async {
    if (state.isLoadingExpenses || !state.expenseHasMore) return;

    state = state.copyWith(isLoadingExpenses: true);

    try {
      final nextPage = state.expensePage + 1;

      final moreData = await _fetchExpenses(
        state.expenseFromDate,
        state.expenseToDate,
        state.expenseCategory,
        page: nextPage,
      );

      state = state.copyWith(
        expenseItems: [...state.expenseItems, ...moreData],
        isLoadingExpenses: false,
        expensePage: nextPage,
        expenseHasMore: moreData.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(isLoadingExpenses: false, error: e.toString());
    }
  }

  // =======================================================
  // LOCAL ADD
  // =======================================================
  void addExpense(Transaction newExpense) {
    state = state.copyWith(expenseItems: [newExpense, ...state.expenseItems]);
  }

  void addReserve(Transaction newReserve) {
    state = state.copyWith(reserveItems: [newReserve, ...state.reserveItems]);
  }

  // =======================================================
  // DELETE + UNDO
  // =======================================================
  void deleteById(int id) {
    Transaction? item;
    int index = -1;

    final expenseIndex = state.expenseItems.indexWhere((t) => t.id == id);

    if (expenseIndex != -1) {
      item = state.expenseItems[expenseIndex];
      index = expenseIndex;

      final updated = [...state.expenseItems]..removeAt(expenseIndex);

      state = state.copyWith(
        expenseItems: updated,
        lastDeleted: item,
        lastDeletedIndex: index,
      );
    } else {
      final reserveIndex = state.reserveItems.indexWhere((t) => t.id == id);

      if (reserveIndex == -1) return;

      item = state.reserveItems[reserveIndex];
      index = reserveIndex;

      final updated = [...state.reserveItems]..removeAt(reserveIndex);

      state = state.copyWith(
        reserveItems: updated,
        lastDeleted: item,
        lastDeletedIndex: index,
      );
    }

    _undoTimer?.cancel();

    _undoTimer = Timer(const Duration(seconds: 3), () {
      _commitDelete(item!);
    });
  }

  void undo() {
    final item = state.lastDeleted;
    final index = state.lastDeletedIndex;

    if (item == null || index == null) return;

    _undoTimer?.cancel();

    if (item.isExpense) {
      final updated = [...state.expenseItems];
      updated.insert(index, item);

      state = state.copyWith(expenseItems: updated, clearUndo: true);
    } else {
      final updated = [...state.reserveItems];
      updated.insert(index, item);

      state = state.copyWith(reserveItems: updated, clearUndo: true);
    }
  }

  Future<void> _commitDelete(Transaction item) async {
    try {
      if (item.isExpense) {
        await DeleteService().deleteExpense(item.id);
      } else {
        await DeleteService().deleteReserve(item.id);
      }
    } catch (e) {
      undo(); // rollback
    }

    state = state.copyWith(clearUndo: true);
  }

  // =======================================================
  // LOGOUT RESET
  // =======================================================
  void clear() {
    _undoTimer?.cancel();
    state = TransactionState.initial();
  }
}

Future<List<Transaction>> _fetchExpenses(
  String? fromDate,
  String? toDate,
  int? category, {
  required int page,
}) async {
  List<Expense> expenses = [];

  // =====================================================
  // CASE 1: No filters
  // =====================================================
  if (fromDate == null && toDate == null && category == null) {
    expenses = await FetchService().fetchExpenses(page: page, size: 10);
  }
  // =====================================================
  // CASE 2: Date range only
  // =====================================================
  else if (fromDate != null && toDate != null && category == null) {
    expenses = await FetchService().fetchExpensesByDateRange(
      DateTime.parse(fromDate),
      DateTime.parse(toDate),
      page: page,
      size: 10,
    );
  }
  // =====================================================
  // CASE 3: Category + Date range
  // =====================================================
  else if (category != null && fromDate != null && toDate != null) {
    expenses = await FetchService().fetchExpensesByCategoryAndDateRange(
      DateTime.parse(fromDate),
      DateTime.parse(toDate),
      category,
      page: page,
      size: 10,
    );
  }
  // =====================================================
  // CASE 4: Fallback
  // (future-proof for unsupported combinations)
  // =====================================================
  else {
    expenses = await FetchService().fetchExpenses(page: page, size: 10);
  }

  // =====================================================
  // FINAL MAP
  // =====================================================
  return expenses.map(_mapExpenseToTransaction).toList();
}
// =======================================================
// provider
// =======================================================

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>(
      (ref) => TransactionNotifier(),
    );
Transaction _mapExpenseToTransaction(Expense e) {
  return Transaction(
    id: e.id,
    title: e.categoryName,
    amount: e.amount,
    date: DateFormat('yyyy-MM-dd').format(e.expenseDate),
    icon: mapCategoryToIcon(e.categoryName),
    isExpense: true,
  );
}
