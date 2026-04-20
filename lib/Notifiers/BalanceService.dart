import 'package:etrace/Api/ApiClient.dart';
import 'package:etrace/model/Balance.dart';

class BalanceService {
  final dio = ApiClient().dio;
  bool useMock = true; // toggle this for mock or real API

  Future<Balance> fetchCombinedBalance() async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));

      return Balance(accountBalance: 2500.75, reservedBalance: 800.25);
    }

    final accountResponse = await dio.get("/api/auth/balance");
    final reserveResponse = await dio.get("/api/reserve/balance");

    final account = (accountResponse.data['balance'] as num).toDouble();
    final reserved = (reserveResponse.data['reserved'] as num).toDouble();

    return Balance(accountBalance: account, reservedBalance: reserved);
  }
}
