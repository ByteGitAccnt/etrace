import 'package:etrace/Api/ApiClient.dart';
import 'package:etrace/model/Balance.dart';

class BalanceService {
  final dio = ApiClient().dio;
  //bool useMock = false; // toggle this for mock or real API

  Future<Balance> fetchCombinedBalance() async {
    final accountResponse = await dio.get("/api/Accnt/balance");
    final reserveResponse = await dio.get("/api/reserve/balance");

    final account = (accountResponse.data['balance'] as num).toDouble();
    final reserved = (reserveResponse.data['reserved'] as num).toDouble();

    return Balance(accountBalance: account, reservedBalance: reserved);
  }
}
