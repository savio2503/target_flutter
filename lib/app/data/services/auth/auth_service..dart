import 'package:get/get.dart';
import 'package:target/app/data/models/user.dart';
import 'package:target/app/data/models/user_login_request.dart';
import 'package:target/app/data/services/auth/repositoy.dart';
import 'package:target/app/data/services/storage/storage_service.dart';

//class used to save server cookies and tokens
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

    user.value = null;
    await _repository.login(userLoginRequestModel);
    await _storageService.saveToken("token");
    await getUser();
  }

  Future getUser() async {
    if (user.value == null) {
      await _repository.getUser().then((value) => user.value = value,
          onError: (error) => user.value = null);
    }
  }

  Future<void> logout() async {
    await _storageService.saveToken("");
    await _storageService.saveSession("");

    user.value = null;
  }
}
