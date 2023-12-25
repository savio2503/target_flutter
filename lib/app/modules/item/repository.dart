import 'package:target/app/data/models/deposit.dart';
import 'package:target/app/data/models/target_request.dart';
import 'package:target/app/data/provider/api.dart';

class ItemRepository {
  final Api _api;

  ItemRepository(this._api);

  Future<void> editarTarget(TargetRequestModel target) =>
      _api.editarTarget(target);

  Future<void> deleteTarget(int id) => _api.deleteTarget(id);

  Future<List<DeposityModel>> getAllDeposity(int targetId) =>
      _api.getAllDeposity(targetId);

  Future<String> getImagem(int id) => _api.getImagem(id);
}
