import 'package:etrace/Api/FetchService.dart';
import 'package:etrace/Model/Category.dart';
import 'package:etrace/Notifiers/CategoryState.dart';
import 'package:flutter_riverpod/legacy.dart';

class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(const CategoryState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true);

    try {
      // call API
      List<Category> data = [];
      await Future.delayed(const Duration(seconds: 1));
      data = await FetchService().fetchCategories();
      data = [Category(id: 1, name: "Food"), Category(id: 2, name: "Travel")];

      state = state.copyWith(items: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void addIfNotExists(String categoryName) {
    final exists = state.items.any(
      (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
    );

    if (exists) return;

    // temporary ID (backend will have real one later)
    final newCategory = Category(
      id: DateTime.now().millisecondsSinceEpoch, // temp
      name: categoryName,
    );

    state = state.copyWith(items: [...state.items, newCategory]);
  }
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>(
  (ref) => CategoryNotifier(),
);
