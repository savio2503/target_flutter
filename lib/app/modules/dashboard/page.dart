import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:target/app/core/theme/app_theme.dart';
import 'package:target/app/data/models/target.dart';
import 'package:target/app/modules/dashboard/controller.dart';
import 'package:target/app/tools/functions.dart';
import 'package:target/routes/routes.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 82;
    final double width_grid = (MediaQuery.of(context).size.width / 2) - 41;

    //printd("width: $width");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            var created = await Get.toNamed(Routes.add);

            if (created != null && created)
              controller.getAllTarget();
          },
          icon: const Icon(Icons.add, color: Colors.white,),
        ),
        title: const Text('Objetivos', style: TextStyle(color: Colors.white,),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () async {
              await Get.toNamed(Routes.login);

              controller.getAllTarget();
            },
            icon: const Icon(Icons.account_circle, color: Colors.white,),
          ),
        ],
      ),
      floatingActionButton: Obx(() => btnDeposit(controller)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Obx(() {
        if (controller.loading.value) {
          return const Column(
            children: [
              Spacer(),
              Center(
                child: Text('carregando'),
              ),
              Spacer(),
            ],
          );
        }
        final list = controller.listaTargets.value;
        if (list.isEmpty) {
          return const Align(
            alignment: Alignment.center,
            child: Text("Não contém objetivos, por favor adicione novos"),
          );
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Total Investido: ${sumTotalList(list)}"),
            ),
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 75.0),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: List.generate(list.length, (index) {
                  return GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> arg = {
                        "target": list[index]
                      };
                      var edit = await Get.toNamed(
                        Routes.item,
                        arguments: arg,
                      );
                      printd("edit: $edit");
                      if (edit != null && edit) controller.getAllTarget();
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 18.0 / 11.0,
                            child: returnImageFromString(
                              list[index].imagem,
                              width_grid,
                              const Icon(
                                Icons.local_mall,
                                size: 50,
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
                                  "${list[index].posicao} - ${list[index].descricao}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                fittedBox(list[index]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }
}

String sumTotalList(List<TargetModel> list) {
  num sum = 0.0;

  for (var i = 0; i < list.length; i++) {
    sum += list[i].valorAtual;
  }

  return NumberFormat.simpleCurrency().format(sum);
}

Widget btnDeposit(DashboardController controller) {
  //printd("btnDeposit");
  if (controller.sucessReturn.value && controller.countTargets.value != 0) {
    return SizedBox(
      width: 250,
      child: GestureDetector(
        child: Image.asset('assets/images/depositarOuRetirar.png'),
        onTap: () async {
          await Get.toNamed(Routes.deposit);
          controller.getAllTarget();
        },
      ),
    );
  } else {
    return Container();
  }
}

Widget fittedBox(TargetModel target) {
  return Center(
    child: FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
          //'${NumberFormat.simpleCurrency().format(target.valorAtual)} / ${target.porcetagem} %\n${NumberFormat.simpleCurrency().format(target.valor)}'),
          '${target.porcetagem.toStringAsFixed(2)} %'),
    ),
  );
}
