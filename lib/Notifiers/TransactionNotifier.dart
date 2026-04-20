import 'dart:async';
import 'package:etrace/Model/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super(_initialData());

  Transaction? _lastDeleted;
  int? _lastDeletedIndex;
  Timer? _timer;

  // ✅ expose last deleted safely
  Transaction? get lastDeleted => _lastDeleted;
  int? get lastDeletedIndex => _lastDeletedIndex;

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
        title: "Gas",
        amount: 500,
        date: "Apr 13",
        icon: Icons.local_gas_station,
      ),
      Transaction(
        id: 12,
        title: "Coffee",
        amount: 150,
        date: "Apr 14",
        icon: Icons.coffee,
      ),
      Transaction(
        id: 13,
        title: "Books",
        amount: 300,
        date: "Apr 15",
        icon: Icons.book,
      ),
      Transaction(
        id: 14,
        title: "Parking",
        amount: 50,
        date: "Apr 16",
        icon: Icons.local_parking,
      ),
      Transaction(
        id: 15,
        title: "Haircut",
        amount: 400,
        date: "Apr 17",
        icon: Icons.cut,
      ),
      Transaction(
        id: 16,
        title: "Doctor Visit",
        amount: 800,
        date: "Apr 18",
        icon: Icons.local_hospital,
      ),
      Transaction(
        id: 17,
        title: "Phone Bill",
        amount: 600,
        date: "Apr 19",
        icon: Icons.phone,
      ),
      Transaction(
        id: 18,
        title: "Gym Membership",
        amount: 1500,
        date: "Apr 20",
        icon: Icons.sports_gymnastics,
      ),
    ];
  }

  // ✅ CHANGED: delete by ID instead of index
  Duration deleteById(int id) {
    final index = state.indexWhere((t) => t.id == id);
    if (index == -1) return const Duration(seconds: 0);

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






/* 
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
 */