import 'package:get/get.dart';
import 'package:target/app/data/provider/api.dart';
import 'package:target/app/modules/deposit/controller.dart';
import 'package:target/app/modules/deposit/repository.dart';

class DepositBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<DepositController>(() => DepositController(DepositRepository(Get.find<Api>())));
  }
}