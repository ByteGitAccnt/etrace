import 'dart:async';
import 'package:etrace/Model/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super(_initialData());

  Transaction? _lastDeleted;
  int? _lastDeletedIndex;
  Timer? _timer;

  static List<Transaction> _initialData() {
    return [
      Transaction(
        id: 1,
        title: "Food",
        amount: 250,
        date: "Apr 3",
        icon: Icons.restaurant,
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
      Transaction(
        id: 6,
        title: "Internet",
        amount: 999,
        date: "Apr 8",
        icon: Icons.wifi,
      ),
      Transaction(
        id: 7,
        title: "Movie",
        amount: 400,
        date: "Apr 9",
        icon: Icons.movie,
      ),
      Transaction(
        id: 8,
        title: "Gym",
        amount: 1200,
        date: "Apr 10",
        icon: Icons.fitness_center,
      ),
      Transaction(
        id: 9,
        title: "Groceries",
        amount: 1800,
        date: "Apr 11",
        icon: Icons.local_grocery_store,
      ),
      Transaction(
        id: 10,
        title: "Dining Out",
        amount: 600,
        date: "Apr 12",
        icon: Icons.fastfood,
      ),
      Transaction(
        id: 11,
        title: "Internet",
        amount: 999,
        date: "Apr 8",
        icon: Icons.wifi,
      ),
      Transaction(
        id: 12,
        title: "Movie",
        amount: 400,
        date: "Apr 9",
        icon: Icons.movie,
      ),
      Transaction(
        id: 13,
        title: "Gym",
        amount: 1200,
        date: "Apr 10",
        icon: Icons.fitness_center,
      ),
      Transaction(
        id: 9,
        title: "Groceries",
        amount: 1800,
        date: "Apr 11",
        icon: Icons.local_grocery_store,
      ),
      Transaction(
        id: 10,
        title: "Dining Out",
        amount: 600,
        date: "Apr 12",
        icon: Icons.fastfood,
      ),
    ];
  }

  Duration delete(int index) {
    final item = state[index];

    _timer?.cancel();

    _lastDeleted = item;
    _lastDeletedIndex = index;

    final newList = [...state]..removeAt(index);
    state = newList;

    _timer = Timer(const Duration(seconds: 3), () {
      print("Final delete: ${item.id}");
      _lastDeleted = null;
      _lastDeletedIndex = null;
    });
    return const Duration(seconds: 3);
  }

  void undo() {
    if (_lastDeleted == null || _lastDeletedIndex == null) return;

    _timer?.cancel();

    final newList = [...state];
    newList.insert(_lastDeletedIndex!, _lastDeleted!);

    state = newList;

    _lastDeleted = null;
    _lastDeletedIndex = null;
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>(
      (ref) => TransactionNotifier(),
    );
