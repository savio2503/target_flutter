import 'package:target/app/data/models/target.dart';
import 'package:target/app/data/provider/api.dart';

class DashboardRepository {
  final Api _api;

  DashboardRepository(this._api);

  Future<List<TargetModel>> getTargets(bool? ative) => _api.getTargets(ative);
}
