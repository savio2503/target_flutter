import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:target/app/data/models/target.dart';
import 'package:target/app/modules/dashboard/controller.dart';
import 'package:target/routes/routes.dart';

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
      width: 50,
      child: GestureDetector(
        child: const Icon(
          Icons.currency_exchange,
          size: 50.0,
        ), //Image.asset('assets/images/depositarOuRetirar.png'),
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
