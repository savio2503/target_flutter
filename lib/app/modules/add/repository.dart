import 'package:target/app/data/models/target_request.dart';
import 'package:target/app/data/provider/api.dart';

class AddRepository {
  final Api _api;

  AddRepository(this._api);

  Future<void> addTarget(TargetRequestModel target) => _api.addTarget(target);
}
