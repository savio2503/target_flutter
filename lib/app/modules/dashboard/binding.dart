import 'package:get/get.dart';
import 'package:target/app/data/provider/api.dart';
import 'package:target/app/modules/dashboard/controller.dart';
import 'package:target/app/modules/dashboard/repository.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
        () => DashboardController(DashboardRepository(Get.find<Api>())));
  }
}
