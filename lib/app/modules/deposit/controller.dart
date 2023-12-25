import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:target/app/modules/deposit/repository.dart';
import 'package:target/app/tools/functions.dart';

class DepositController extends GetxController {
  final DepositRepository _repository;

  var valorController = TextEditingController(text: 'R\$ 0,00');

  DepositController(this._repository);

  Future<void> send(bool positivo) async {
    try {
      double valor = currencyToDouble(valorController.text);

      if (valor != 0.0) {
        valor = positivo ? valor : (-1 * valor);

        printd("chamando o deposito, com o valor de: " + valor.toString());

        await _repository.deposit(valor);

        Get.back();
      }
    } catch (err) {
      printd("error ao enviar o deposito: " + err.toString());
    }
  }
}
