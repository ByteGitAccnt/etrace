import 'package:etrace/Model/Transaction.dart';

class TransactionState {
  final List<Transaction> items;

  // pagination
  final int page;
  final bool hasMore;
  final bool isLoading;

  // filters (acts as "search")
  final String? fromDate;
  final String? toDate;
  final String? category;

  // undo
  final Transaction? lastDeleted;
  final int? lastDeletedIndex;

  final String? error;

  const TransactionState({
    this.items = const [],
    this.page = 0,
    this.hasMore = true,
    this.isLoading = false,
    this.fromDate,
    this.toDate,
    this.category,
    this.lastDeleted,
    this.lastDeletedIndex,
    this.error,
  });

  TransactionState copyWith({
    List<Transaction>? items,
    int? page,
    bool? hasMore,
    bool? isLoading,
    String? fromDate,
    String? toDate,
    String? category,
    Transaction? lastDeleted,
    int? lastDeletedIndex,
    String? error,
    bool clearUndo = false,
  }) {
    return TransactionState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      category: category ?? this.category,
      lastDeleted: clearUndo ? null : (lastDeleted ?? this.lastDeleted),
      lastDeletedIndex: clearUndo
          ? null
          : (lastDeletedIndex ?? this.lastDeletedIndex),
      error: error,
    );
  }
}
