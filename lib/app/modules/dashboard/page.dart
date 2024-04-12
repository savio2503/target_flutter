import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:target/app/data/services/auth/auth_service..dart';
import 'package:target/app/modules/dashboard/commum.dart';
import 'package:target/app/modules/dashboard/controller.dart';
import 'package:target/app/tools/functions.dart';
import 'package:target/routes/routes.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

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
              'Targets',
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
                  "IN PROGRESS",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "COMPLETED",
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
                //ProgressTarget(controller),
                //ConcludedTarget(controller),
                bodyDashboard(context, true),
                bodyDashboard(context, false),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget bodyDashboard(BuildContext context, bool inProgress) {
    final double widthScreen = MediaQuery.of(context).size.width - 82;
    final authService = Get.find<AuthService>();
    final listTarget =
        inProgress ? controller.progressTargets : controller.completeTargets;

    if (!authService.isLogged) {
      return const Align(
        alignment: Alignment.center,
        child: Text("Please login"),
      );
    }

    if (controller.loading.value) {
      return const Column(
        children: [
          Spacer(),
          Center(
            child: Text('loading'),
          ),
          Spacer(),
        ],
      );
    }

    if (listTarget.isEmpty) {
      return Align(
        alignment: Alignment.center,
        child: Text(inProgress
            ? "You have no goals!"
            : "You have no completed goals!"),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
              "Total Invested: ${NumberFormat.simpleCurrency().format(inProgress ? controller.sumOfAssets.value : controller.sumOfCompleted.value)}"),
        ),
        Expanded(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 75.0),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: List.generate(
              listTarget.length,
              (index) {
                return GestureDetector(
                  onTap: () async {
                    Map<String, dynamic> arg = {"target": listTarget[index]};
                    var edit = await Get.toNamed(
                      Routes.item,
                      arguments: arg,
                    );

                    if (edit != null && edit) controller.getAllTarget();
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            height: (widthScreen / 2) - 45,
                            width: (widthScreen / 2),
                            child: returnImageFromString(
                              listTarget[index].imagem,
                              widthScreen,
                              const Icon(
                                Icons.local_mall,
                                size: 50,
                              ),
                              null,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${listTarget[index].posicao} - ${listTarget[index].descricao}",
                                overflow: TextOverflow.ellipsis,
                              ),
                              fittedBox(listTarget[index]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
