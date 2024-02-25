import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:target/app/data/models/target.dart';
import 'package:target/app/modules/dashboard/commum.dart';
import 'package:target/app/modules/dashboard/controller.dart';
import 'package:target/app/tools/functions.dart';
import 'package:target/routes/routes.dart';

import '../../data/services/auth/auth_service..dart';

class ConcludedTarget extends StatefulWidget {
  const ConcludedTarget(this.controller, {super.key});

  final DashboardController controller;

  @override
  State<ConcludedTarget> createState() => _ConcludedTargetState();
}

class _ConcludedTargetState extends State<ConcludedTarget> {
  List<TargetModel> targetsConcluidos = [];
  final _authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    final List<TargetModel> targets = widget.controller.listaTargets.value;
    final double width = MediaQuery.of(context).size.width - 82;
    //final double width_grid = (MediaQuery.of(context).size.width / 2) - 41;

    targetsConcluidos.clear();

    for (var target in targets) {
      if (!target.ativo) {
        //printd("Adicionando nos concluidos: $target");
        targetsConcluidos.add(target);
      }
    }
    if (widget.controller.loading.value) {
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

    if (!_authService.isLogged) {
      return const Align(
        alignment: Alignment.center,
        child: Text("Por Favor, realizar login"),
      );
    }

    if (targetsConcluidos.isEmpty) {
      return const Align(
        alignment: Alignment.center,
        child: Text("Você não possui objetivos concluidos!"),
      );
    }
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("Total Investido: ${NumberFormat.simpleCurrency().format(widget.controller.sumOfCompleted.value)}"),
        ),
        Expanded(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 75.0),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: List.generate(targetsConcluidos.length, (index) {
              return GestureDetector(
                onTap: () async {
                  Map<String, dynamic> arg = {
                    "target": targetsConcluidos[index]
                  };
                  var edit = await Get.toNamed(
                    Routes.item,
                    arguments: arg,
                  );
                  printd("edit: $edit");
                  if (edit != null && edit) widget.controller.getAllTarget();
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 18.0 / 11.0,
                        child: returnImageFromString(
                          targetsConcluidos[index].imagem,
                          width,
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
                              "${targetsConcluidos[index].posicao} - ${targetsConcluidos[index].descricao}",
                              overflow: TextOverflow.ellipsis,
                            ),
                            fittedBox(targetsConcluidos[index]),
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
  }
}
