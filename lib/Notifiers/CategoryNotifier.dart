import 'package:etrace/Model/Category.dart';
import 'package:etrace/Notifiers/CategoryState.dart';
import 'package:flutter_riverpod/legacy.dart';

class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(const CategoryState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true);

    try {
      // call API
      final data = [
        Category(id: 1, name: "Food"),
        Category(id: 2, name: "Travel"),
      ];

      state = state.copyWith(items: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>(
  (ref) => CategoryNotifier(),
);
