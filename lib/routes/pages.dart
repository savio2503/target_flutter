import 'package:get/get.dart';
import 'package:target/app/modules/add/binding.dart';
import 'package:target/app/modules/add/page.dart';
import 'package:target/app/modules/dashboard/binding.dart';
import 'package:target/app/modules/dashboard/page.dart';
import 'package:target/app/modules/deposit/binding.dart';
import 'package:target/app/modules/deposit/page.dart';
import 'package:target/app/modules/item/binding.dart';
import 'package:target/app/modules/item/page.dart';
import 'package:target/app/modules/login/binding.dart';
import 'package:target/app/modules/login/page.dart';
import 'package:target/routes/routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.add,
      page: () => AddPage(),
      binding: AddBinding(),
    ),
    GetPage(
      name: Routes.item,
      page: () => ItemPage(),
      binding: ItemBinding(),
    ),
    GetPage(
      name: Routes.deposit,
      page: () => const DepositPage(),
      binding: DepositBinding(),
    ),
  ];
}
