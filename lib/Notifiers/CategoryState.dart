import 'package:etrace/Model/Category.dart';

class CategoryState {
  final List<Category> items;
  final bool isLoading;

  const CategoryState({this.items = const [], this.isLoading = false});

  CategoryState copyWith({List<Category>? items, bool? isLoading}) {
    return CategoryState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
