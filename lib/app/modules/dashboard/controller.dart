import 'package:get/get.dart';
import 'package:target/app/data/models/target.dart';
import 'package:target/app/data/services/auth/auth_service..dart';
import 'package:target/app/modules/dashboard/repository.dart';
import 'package:target/app/tools/functions.dart';

class DashboardController extends GetxController {

  final DashboardRepository _repository;

  DashboardController(this._repository);

  var sucessReturn = false.obs;
  var countTargets = 0.obs;
  RxList<TargetModel> listaTargets = <TargetModel>[].obs;
  RxList<TargetModel> progressTargets = <TargetModel>[].obs;
  RxList<TargetModel> completeTargets = <TargetModel>[].obs;
  var loading = false.obs;
  var sumOfAssets = RxNum(0.0);
  var sumOfCompleted = RxNum(0.0);

  @override
  void onInit() {
    getAllTarget();

    super.onInit();
  }

  getAllTarget() async {

    final _authService = Get.find<AuthService>();

    await _authService.getUser();

    if (_authService.isLogged) {
      loading.value = true;
      _repository.getTargets(null).then((value) {
        print("3: return getTarget: ${value.length}");
        if (value.isEmpty) {
          sucessReturn.value = true;
          loading.value = false;
          listaTargets.clear();
          progressTargets.clear();
          completeTargets.clear();
        } else {
          listaTargets.clear();
          progressTargets.clear();
          completeTargets.clear();

          listaTargets.addAll(value);

          listaTargets.forEach((target) {
            if (target.ativo) {
              progressTargets.add(target);
            } else {
              completeTargets.add(target);
            }
          });

          sucessReturn.value = true;
          loading.value = false;
          countTargets.value = value.length;

          sumOfAssets.value = 0;
          sumOfCompleted.value = 0;

          listaTargets.forEach((element) {
            if (element.ativo) {
              sumOfAssets.value += element.valorAtual;
            } else {
              sumOfCompleted.value += element.valor;
            }
          });
        }
      }, onError: (error) {
        //change([], status: RxStatus.error(error.toString()));
        loading.value = false;
        sucessReturn.value = false;
      });
    }
  }
}
