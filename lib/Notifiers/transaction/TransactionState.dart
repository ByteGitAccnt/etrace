import 'package:etrace/Model/Transaction.dart';

class TransactionState {
  // =========================
  // CACHED DATA
  // =========================
  final List<Transaction> expenseItems;
  final List<Transaction> reserveItems;

  // =========================
  // EXPENSE PAGINATION
  // =========================
  final int expensePage;
  final bool expenseHasMore;

  // =========================
  // LOADING FLAGS
  // =========================
  final bool isLoadingExpenses;
  final bool isLoadingReserves;

  // =========================
  // SESSION LOAD FLAGS
  // =========================
  final bool expensesLoaded;
  final bool reservesLoaded;

  // =========================
  // EXPENSE FILTERS
  // =========================
  final String? expenseFromDate;
  final String? expenseToDate;
  final int? expenseCategory;

  // =========================
  // UNDO DELETE
  // =========================
  final Transaction? lastDeleted;
  final int? lastDeletedIndex;

  final String? error;

  const TransactionState({
    this.expenseItems = const [],
    this.reserveItems = const [],

    this.expensePage = 0,
    this.expenseHasMore = true,

    this.isLoadingExpenses = false,
    this.isLoadingReserves = false,

    this.expensesLoaded = false,
    this.reservesLoaded = false,

    this.expenseFromDate,
    this.expenseToDate,
    this.expenseCategory,

    this.lastDeleted,
    this.lastDeletedIndex,

    this.error,
  });

  TransactionState copyWith({
    List<Transaction>? expenseItems,
    List<Transaction>? reserveItems,

    int? expensePage,
    bool? expenseHasMore,

    bool? isLoadingExpenses,
    bool? isLoadingReserves,

    bool? expensesLoaded,
    bool? reservesLoaded,

    String? expenseFromDate,
    String? expenseToDate,
    int? expenseCategory,

    Transaction? lastDeleted,
    int? lastDeletedIndex,

    String? error,

    bool clearUndo = false,
  }) {
    return TransactionState(
      expenseItems: expenseItems ?? this.expenseItems,
      reserveItems: reserveItems ?? this.reserveItems,

      expensePage: expensePage ?? this.expensePage,
      expenseHasMore: expenseHasMore ?? this.expenseHasMore,

      isLoadingExpenses: isLoadingExpenses ?? this.isLoadingExpenses,
      isLoadingReserves: isLoadingReserves ?? this.isLoadingReserves,

      expensesLoaded: expensesLoaded ?? this.expensesLoaded,
      reservesLoaded: reservesLoaded ?? this.reservesLoaded,

      expenseFromDate: expenseFromDate ?? this.expenseFromDate,
      expenseToDate: expenseToDate ?? this.expenseToDate,
      expenseCategory: expenseCategory ?? this.expenseCategory,

      lastDeleted: clearUndo ? null : (lastDeleted ?? this.lastDeleted),
      lastDeletedIndex: clearUndo
          ? null
          : (lastDeletedIndex ?? this.lastDeletedIndex),

      error: error,
    );
  }

  factory TransactionState.initial() => const TransactionState();
}
