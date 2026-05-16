import 'package:etrace/Model/Category.dart';

class CategoryState {
  final List<Category> items;
  // True only while an active backend request is happening
  final bool isLoading;
  // True once categories have been successfully loaded at least once
  final bool isLoaded;
  //Optional error for debugging / UI messaging
  final String? errorMessage;

  const CategoryState({
    this.items = const [],
    this.isLoading = false,
    this.isLoaded = false,
    this.errorMessage,
  });

  CategoryState copyWith({
    List<Category>? items,
    bool? isLoading,
    bool? isLoaded,
    String? errorMessage,
  }) {
    return CategoryState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      errorMessage: errorMessage,
    );
  }

  /// Useful for logout / full reset
  factory CategoryState.initial() => const CategoryState();
}
