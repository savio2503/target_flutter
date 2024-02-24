import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:target/app/modules/dashboard/commum.dart';
import 'package:target/app/modules/dashboard/concluded.dart';
import 'package:target/app/modules/dashboard/progress.dart';
import 'package:target/app/modules/dashboard/controller.dart';
import 'package:target/routes/routes.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

    //printd("width: $width");

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                var created = await Get.toNamed(Routes.add);

                if (created != null && created) await controller.getAllTarget();
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            title: const Text(
              'Objetivos',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue,
            actions: [
              IconButton(
                onPressed: () async {
                  await Get.toNamed(Routes.login);

                  await controller.getAllTarget();
                },
                icon: const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Text(
                  "EM PROGRESSO",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "CONCLUIDOS",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Obx(() => btnDeposit(controller)),
          body: Obx(() {
            return TabBarView(
              children: [
                ProgressTarget(controller, controller.listaTargets.value),
                ConcludedTarget(controller, controller.listaTargets.value),
              ],
            );
          }),
        ),
      ),
    );
  }
}

