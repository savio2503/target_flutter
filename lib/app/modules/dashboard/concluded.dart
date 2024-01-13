import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:target/app/data/models/target.dart';
import 'package:target/app/modules/dashboard/commum.dart';
import 'package:target/app/modules/dashboard/controller.dart';
import 'package:target/app/tools/functions.dart';
import 'package:target/routes/routes.dart';

class ConcludedTarget extends StatefulWidget {
  const ConcludedTarget(this.controller, this.targets, {super.key});

  final DashboardController controller;
  final List<TargetModel> targets;

  @override
  State<ConcludedTarget> createState() => _ConcludedTargetState();
}

class _ConcludedTargetState extends State<ConcludedTarget> {
  List<TargetModel> targetsConcluidos = [];

  @override
  Widget build(BuildContext context) {
    targetsConcluidos.clear();

    for (var target in widget.targets) {
      if (!target.ativo) {
        printd("Adicionando nos concluidos: $target");
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
          child: Text("Total Investido: ${sumTotalList(targetsConcluidos)}"),
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
                          100,
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