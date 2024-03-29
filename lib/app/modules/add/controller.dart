import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:target/app/core/image_callback.dart';
import 'package:target/app/data/models/target_request.dart';
import 'package:target/app/modules/add/repository.dart';
import 'package:target/app/tools/functions.dart';

class AddController extends GetxController implements ImageCallback {
  final AddRepository _repository;

  var descricaoController = TextEditingController();
  var valorController = TextEditingController(text: ' 0,00');
  var peso = 1.obs;
  var enable = false.obs;
  var image = " ".obs;
  var selectCoin = "".obs;
  var coinId = 1.obs;
  var imageBase64 = "";

  AddController(this._repository);

  void setCoin(String value) => selectCoin.value = value;

  void setCoinId(int value) => coinId.value = (value + 1);

  void setDescricao(String value) => descricaoController.text = value;

  void setImage(String value) => image.value = value;

  void setValor(double value) =>
      valorController.text = NumberFormat.simpleCurrency().format(value);

  void check(String aux) {
    String descricao = descricaoController.text;
    String valor = valorController.text;

    //printd("d: '$descricao', v: '$valor'");

    if (descricao.isEmpty || (valor.isEmpty || valor.contains(" 0,00"))) {
      enable.value = false;
      //printd("false");
      return;
    }

    //printd("true");
    enable.value = true;
    return;
  }

  send() async {
    try {
      var valor = currencyToDouble(valorController.text);

      var target = TargetRequestModel(
        descricao: descricaoController.text,
        valor: valor,
        posicao: peso.value,
        imagem: imageBase64.isEmpty ? image.value : imageBase64,
        coin: coinId.value,
      );

      await _repository.addTarget(target);

      Get.back(result: true);
    } catch (error) {
      printd("erro ao inserir/editar um novo objetivo: $error");
    }
  }

  void setPeso(dynamic value) => peso.value = value.toInt();

  @override
  void onImageReceived(String base64Image) {
    imageBase64 = base64Image;
  }
}
