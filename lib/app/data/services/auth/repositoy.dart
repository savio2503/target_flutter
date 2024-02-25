import 'package:target/app/data/models/user.dart';
import 'package:target/app/data/models/user_login_request.dart';
import 'package:target/app/data/provider/api.dart';

class AuthRepository {
  final Api _api;

  AuthRepository(this._api);

  Future<void> login(
          UserLoginRequestModel userLoginRequestModel) =>
      _api.login(userLoginRequestModel);

  Future<UserModel> getUser() => _api.getUser();
}
