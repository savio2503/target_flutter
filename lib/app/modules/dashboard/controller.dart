import 'package:get/get.dart';
import 'package:target/app/data/models/target.dart';
import 'package:target/app/data/services/auth/auth_service..dart';
import 'package:target/app/modules/dashboard/repository.dart';
import 'package:target/app/tools/functions.dart';

class DashboardController extends GetxController {
  //with StateMixin<List<TargetModel>> {

  final DashboardRepository _repository;

  DashboardController(this._repository);

  var sucessReturn = false.obs;
  var countTargets = 0.obs;
  RxList<TargetModel> listaTargets = <TargetModel>[].obs;
  var loading = false.obs;

  @override
  void onInit() {
    getAllTarget();

    super.onInit();
  }

  getAllTarget() {
    printd("getAllTarget()");
    final _authService = Get.find<AuthService>();

    if (_authService.isLogged) {
      loading.value = true;
      _repository.getTargets(null).then((value) {
        if (value.isEmpty) {
          sucessReturn.value = true;
          loading.value = false;
        } else {
          listaTargets.value = value;
          sucessReturn.value = true;
          loading.value = false;
          countTargets.value = value.length;
        }
      }, onError: (error) {
        //change([], status: RxStatus.error(error.toString()));
        loading.value = false;
        sucessReturn.value = false;
      });
    }
  }
}
