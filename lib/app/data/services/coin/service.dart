import 'package:get/get.dart';
import 'package:target/app/data/models/coin.dart';
import 'package:target/app/data/services/coin/repository.dart';
import 'package:target/app/tools/functions.dart';

class CoinService extends GetxService {

  final CoinRepository _repository;
  var _coins = <CoinModel>[];

  List<CoinModel> get coins => _coins;

  CoinService(this._repository);

  @override
  void onInit() async {
    await getCoins();
    super.onInit();
  }

  Future<void> getCoins() async {
    _coins = await _repository.getAllCoins();
  }
}