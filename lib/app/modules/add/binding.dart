import 'package:get/get.dart';
import 'package:target/app/data/provider/api.dart';
import 'package:target/app/modules/add/controller.dart';
import 'package:target/app/modules/add/repository.dart';

class AddBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddController>(
        () => AddController(AddRepository(Get.find<Api>())));
  }
}
