import 'package:etrace/Model/Transaction.dart';
import 'package:etrace/Notifiers/SearchState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  Future<void> search({
    String? fromDate,
    String? toDate,
    String? category,
  }) async {
    state = state.copyWith(isLoading: true, page: 0);

    // API decision (same as before)

    final fakeData = [
      Transaction(
        id: 1,
        title: "Mock",
        amount: 200,
        date: "Apr 5",
        icon: Icons.shopping_cart,
      ),
      Transaction(
        id: 2,
        title: "Travel",
        amount: 1200,
        date: "Apr 5",
        icon: Icons.flight,
      ),
      Transaction(
        id: 3,
        title: "Shopping",
        amount: 800,
        date: "Apr 6",
        icon: Icons.shopping_cart,
      ),
      Transaction(
        id: 4,
        title: "Salary",
        amount: 20000,
        date: "Apr 1",
        icon: Icons.work,
      ),
      Transaction(
        id: 5,
        title: "Electricity Bill",
        amount: 1500,
        date: "Apr 7",
        icon: Icons.lightbulb,
      ),
    ];

    state = state.copyWith(
      results: fakeData,
      isLoading: false,
      page: 1,
      hasMore: true, // ✅ make sure this exists
    );
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final moreData = <Transaction>[]; // mock

    state = state.copyWith(
      results: [...state.results, ...moreData],
      isLoading: false,
      page: state.page + 1,
    );
  }

  // ✅ NEW: remove item from search UI
  void removeById(int id) {
    state = state.copyWith(
      results: state.results.where((t) => t.id != id).toList(),
    );
  }

  // ✅ NEW: restore item (undo)
  void addBack(Transaction item) {
    state = state.copyWith(results: [item, ...state.results]);
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(),
);

/* 
class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  Future<void> search({
    String? fromDate,
    String? toDate,
    String? category,
  }) async {
    state = state.copyWith(isLoading: true, page: 0);

    // 👉 decide API based on your cases

    if (fromDate == null && toDate == null && category == null) {
      print("API: fetch all with pagination");
    } else if (category == null) {
      print("API: filter by date");
    } else {
      print("API: filter by date + category");
    }

    // TODO: replace with real API response
    final fakeData = [
      Transaction(
        id: 100,
        title: "Mock",
        amount: 200,
        date: "Apr 5",
        icon: Icons.shopping_cart,
      ),
    ];

    state = state.copyWith(results: fakeData, isLoading: false, page: 1);
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    // TODO: API call with page

    final moreData = <Transaction>[]; // mock

    state = state.copyWith(
      results: [...state.results, ...moreData],
      isLoading: false,
      page: state.page + 1,
    );
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(),
);
 */
