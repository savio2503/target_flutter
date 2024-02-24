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
    await getUser();

    super.onInit();
  }

  Future<void> login(UserLoginRequestModel userLoginRequestModel) async {
    //printd("in login service");
    user.value = null;
    await _repository.login(userLoginRequestModel);
    await _storageService.saveToken("token");
    await getUser();

    printd("user logado: ${user.value != null ? user.value.toString() : "nulo"}");
    //printd("out login service");
  }

  Future getUser() async {
    if (user.value == null) {
      await _repository.getUser().then((value) => user.value = value,
          onError: (error) => user.value = null);
    }
    printd("user logado: ${user.value != null ? user.value.toString() : "nulo"}");
  }

  Future<void> logout() async {
    await _storageService.saveToken("");
    await _storageService.saveSession("");

    user.value = null;
  }
}
