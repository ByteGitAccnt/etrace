import 'package:etrace/Api/FetchService.dart';
import 'package:etrace/Model/Category.dart';
import 'package:etrace/Notifiers/category/CategoryState.dart';
import 'package:flutter_riverpod/legacy.dart';

class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(CategoryState.initial());

  /// Main loader
  ///
  /// forceRefresh = true
  /// -> always fetch backend
  ///
  /// forceRefresh = false
  /// -> fetch only if not already loaded
  Future<void> load({bool forceRefresh = false}) async {
    // Prevent unnecessary repeated API calls
    if (state.isLoaded && !forceRefresh) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final data = await FetchService().fetchCategories();

      state = state.copyWith(
        items: data,
        isLoading: false,
        isLoaded: true,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Optimistic local category insert
  ///
  /// Used when expense creation introduces a new category
  /// and backend already handles actual persistence.
  void addIfNotExists(String categoryName) {
    final trimmedName = categoryName.trim();

    if (trimmedName.isEmpty) return;

    final exists = state.items.any(
      (c) => c.name.toLowerCase() == trimmedName.toLowerCase(),
    );

    if (exists) return;

    final newCategory = Category(
      id: DateTime.now().millisecondsSinceEpoch, // temporary UI-only ID
      name: trimmedName,
    );

    state = state.copyWith(items: [...state.items, newCategory]);
  }

  /// Optional category removal (future-ready)
  void removeById(int categoryId) {
    state = state.copyWith(
      items: state.items.where((c) => c.id != categoryId).toList(),
    );
  }

  /// Full reset for logout
  void clear() {
    state = CategoryState.initial();
  }
}

// category_provider
final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>(
  (ref) => CategoryNotifier(),
);



/* class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(const CategoryState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true);

    try {
      // call API
      List<Category> data = [];
      await Future.delayed(const Duration(seconds: 1));
      data = await FetchService().fetchCategories();
      //data = [Category(id: 1, name: "Food"), Category(id: 2, name: "Travel")];

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
 */