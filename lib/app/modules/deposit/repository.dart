import 'package:target/app/data/provider/api.dart';

class DepositRepository {
  final Api _api;

  DepositRepository(this._api);

  Future<void> deposit(double amount) => _api.deposit(amount);
}
