import 'package:get/get.dart';
import 'package:target/app/data/models/user.dart';
import 'package:target/app/data/models/user_login_request.dart';
import 'package:target/app/data/services/auth/repositoy.dart';
import 'package:target/app/data/services/storage/storage_service.dart';
import 'package:target/app/tools/functions.dart';

class AuthService extends GetxService {
  final _storageService = Get.find<StorageService>();
  final AuthRepository _repository;
  final user = Rxn<UserModel>();
  bool get isLogged => user.value != null;

  AuthService(this._repository);

  @override
  void onInit() async {
    await _getUser();

    super.onInit();
  }

  Future<void> login(UserLoginRequestModel userLoginRequestModel) async {
    //printd("in login service");
    var userLoginResponse = await _repository.login(userLoginRequestModel);
    await _storageService.saveToken(userLoginResponse.token);
    await _getUser();

    printd(userLoginResponse.token);
    //printd("out login service");
  }

  Future _getUser() {
    return _repository.getUser().then((value) => user.value = value, onError: (error) => user.value = null);
  }

  Future<void> logout() async {
    await _storageService.saveToken("");
    await _storageService.saveSession("");

    user.value = null;
  }
}
