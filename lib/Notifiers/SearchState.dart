import 'package:etrace/Model/Transaction.dart';

class SearchState {
  final List<Transaction> results;
  final bool isLoading;
  final int page;
  final bool hasMore;

  const SearchState({
    this.results = const [],
    this.isLoading = false,
    this.page = 0,
    this.hasMore = true,
  });

  SearchState copyWith({
    List<Transaction>? results,
    bool? isLoading,
    int? page,
    bool? hasMore,
  }) {
    return SearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
