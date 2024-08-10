import 'package:target/app/data/models/deposit.dart';
import 'package:target/app/data/models/user.dart';
import 'package:target/app/data/models/user_login_request.dart';
import 'package:target/app/data/provider/api.dart';

class AuthRepository {
  final Api _api;

  AuthRepository(this._api);

  Future<void> login(
          UserLoginRequestModel userLoginRequestModel) async =>
      await _api.login(userLoginRequestModel);

  Future<UserModel> getUser() => _api.getUser();

  Future<List<DepositModel>> getHistoricUser() async => await _api.getHistoricUser();
}
