import 'dart:async';

import 'package:etrace/Api/DeleteService.dart';
import 'package:etrace/Api/FetchService.dart';
import 'package:etrace/Model/Expense.dart';
import 'package:etrace/Model/Reserved.dart';
import 'package:etrace/Model/Transaction.dart';
import 'package:etrace/Notifiers/transaction/TransactionState.dart';
import 'package:etrace/Utils/mapCategoryToIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier() : super(const TransactionState());

  Timer? _undoTimer;

  //  LOAD (initial + search/filter)
  Future<void> load({
    String? fromDate,
    String? toDate,
    int? category,
    bool isExpense = true,
  }) async {
    state = state.copyWith(
      isLoading: true,
      page: 0,
      items: [],
      hasMore: true,
      fromDate: fromDate,
      toDate: toDate,
      category: category,
      error: null,
    );

    try {
      //we decide the searching combination here
      // Replace with real API
      List<Transaction> data =
          []; // uncomment after all api implementaion is done
      if (isExpense) {
        data = await _fetchExpenses(fromDate, toDate, category, state);
      } else {
        // Implement reserve fetching logic here
        List<Reserved> reserves = await FetchService().fetchReserves();
        data = reserves
            .map(
              (r) => Transaction(
                id: r.id,
                title: r.label,
                amount: r.amount,
                date: "N/A", // Replace with actual date if available
                icon: Icons
                    .account_balance_wallet, // Use a generic icon for reserves
                isExpense: false,
              ),
            )
            .toList();
      }

      state = state.copyWith(
        items: data,
        isLoading: false,
        page: 0,
        hasMore: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // PAGINATION
  Future<void> fetchMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      //  real API using:
      // state.page, state.fromDate, state.toDate, state.category

      final moreData = await _fetchExpenses(
        state.fromDate,
        state.toDate,
        state.category,
        state,
      );

      state = state.copyWith(
        items: [...state.items, ...moreData],
        isLoading: false,
        page: state.page + 1,
        hasMore: moreData.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // DELETE (by ID, NOT index)
  void deleteById(int id) {
    final index = state.items.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final item = state.items[index];

    _undoTimer?.cancel();

    final updatedList = [...state.items]..removeAt(index);

    state = state.copyWith(
      items: updatedList,
      lastDeleted: item,
      lastDeletedIndex: index,
    );

    // optional timer (UI can also control this)
    _undoTimer = Timer(const Duration(seconds: 3), () {
      _commitDelete(item, state);
      state = state.copyWith(clearUndo: true);
    });
  }

  // UNDO
  void undo() {
    final item = state.lastDeleted;
    final index = state.lastDeletedIndex;

    if (item == null || index == null) return;

    _undoTimer?.cancel(); // prevent from backend commit if user undos in time

    final updatedList = [...state.items];
    updatedList.insert(index, item);

    state = state.copyWith(items: updatedList, clearUndo: true);
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>(
      (ref) => TransactionNotifier(),
    );

Future<void> _commitDelete(Transaction item, dynamic state) async {
  try {
    if (item.isExpense) {
      await DeleteService().deleteExpense(item.id);
    } else {
      // reserve case
      await DeleteService().deleteReserve(item.id);
    }
  } catch (e) {
    //rollback if backend fails
    final updatedList = [...state.items];
    updatedList.insert(state.lastDeletedIndex!, item);

    state = state.copyWith(items: updatedList);
  }
  // clear undo state finally
  state = state.copyWith(clearUndo: true);
}

Future<List<Transaction>> _fetchExpenses(
  String? fromDate,
  String? toDate,
  int? category,
  dynamic state,
) async {
  List<Transaction> data = [];
  if (fromDate == null && toDate == null && category == null) {
    List<Expense> expenses = await FetchService().fetchExpenses(
      page: state.page,
      size: 10,
    );
    data = expenses
        .map(
          (e) => Transaction(
            id: e.id,
            title: e.categoryName,
            amount: e.amount,
            date: DateFormat('yyyy-MM-dd').format(e.expenseDate),
            icon: mapCategoryToIcon(e.categoryName),
            isExpense: true,
          ),
        )
        .toList();
  } else if (fromDate != null && toDate != null && category == null) {
    // Implement date range filtering logic here
    List<Expense> expenses = await FetchService().fetchExpensesByDateRange(
      DateTime.parse(fromDate),
      DateTime.parse(toDate),
      page: state.page,
      size: 10,
    );
    data = expenses
        .map(
          (e) => Transaction(
            id: e.id,
            title: e.categoryName,
            amount: e.amount,
            date: DateFormat('yyyy-MM-dd').format(e.expenseDate),
            icon: mapCategoryToIcon(e.categoryName),
            isExpense: true,
          ),
        )
        .toList();
  } else if (category != null && fromDate != null && toDate != null) {
    // Implement category filtering logic here
    List<Expense> expenses = await FetchService()
        .fetchExpensesByCategoryAndDateRange(
          DateTime.parse(fromDate),
          DateTime.parse(toDate),
          category,
          page: state.page,
          size: 10,
        );
    data = expenses
        .map(
          (e) => Transaction(
            id: e.id,
            title: e.categoryName,
            amount: e.amount,
            date: DateFormat('yyyy-MM-dd').format(e.expenseDate),
            icon: mapCategoryToIcon(e.categoryName),
            isExpense: true,
          ),
        )
        .toList();
  } else {
    // Handle other combinations or default case
    List<Expense> expenses = await FetchService().fetchExpenses(
      page: state.page,
      size: 10,
    );
    data = expenses
        .map(
          (e) => Transaction(
            id: e.id,
            title: e.categoryName,
            amount: e.amount,
            date: DateFormat('yyyy-MM-dd').format(e.expenseDate),
            icon: mapCategoryToIcon(e.categoryName),
            isExpense: true,
          ),
        )
        .toList();
  }
  return data;
}
