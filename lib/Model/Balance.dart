class Balance {
  final double accountBalance;
  final double reservedBalance;

  Balance({required this.accountBalance, required this.reservedBalance});

  factory Balance.fromJson(double account, double reserved) {
    return Balance(accountBalance: account, reservedBalance: reserved);
  }
}
