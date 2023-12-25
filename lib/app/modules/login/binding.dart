import 'package:get/get.dart';
import 'package:target/app/modules/login/controller.dart';

class LoginBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<LoginController>(() => LoginController());
  }
}