import 'package:target/app/data/models/coin.dart';
import 'package:target/app/data/provider/api.dart';

class CoinRepository {

  final Api _api;

  CoinRepository(this._api);

  Future<List<CoinModel>> getAllCoins() async => await _api.getAllCoins();
}