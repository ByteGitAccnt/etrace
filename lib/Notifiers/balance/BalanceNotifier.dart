import 'package:etrace/Notifiers/balance/BalanceService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etrace/model/Balance.dart';
import 'package:flutter_riverpod/legacy.dart';

class BalanceNotifier extends StateNotifier<AsyncValue<Balance>> {
  BalanceNotifier(this._service) : super(const AsyncValue.loading());

  final BalanceService _service;

  Future<void> fetchBalance() async {
    try {
      final balance = await _service.fetchCombinedBalance();
      state = AsyncValue.data(balance);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final balanceProvider =
    StateNotifierProvider<BalanceNotifier, AsyncValue<Balance>>(
      (ref) => BalanceNotifier(BalanceService()),
    );
