import 'package:get/get.dart';
import 'package:target/app/data/provider/api.dart';
import 'package:target/app/modules/item/controller.dart';
import 'package:target/app/modules/item/repository.dart';

class ItemBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemController>(
        () => ItemController(ItemRepository(Get.find<Api>())));
  }
}
